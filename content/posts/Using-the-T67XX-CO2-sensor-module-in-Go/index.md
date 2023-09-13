---
title: "Using the T67XX CO₂ Sensor Module in Go"
summary: Getting CO₂ readings and more from the T67XX CO2 Sensor Module in Go
date: 2020-11-30T11:24:00+00:00
draft: false
tags: ["electronics", "Raspberry Pi", "Go", "programming"]
category: ""
description: Wiring up and using the T6713 / T67XX sensor module in Go.
type: Post
---

![T67XX CO₂ sensor datasheet cover](images/T67XX.png#right)

So, you bought four T67XX CO₂ sensors and only once they were delivered started to work out how to get values from them huh? Well I'm right there with you because so did I. and I carefully deposited the results in a new Go lib. Announcing the [Go T67XX CO₂ sensor library](https://github.com/wjessop/T67XX)! This post will give you some details about what these sensors can do, then introduce the library and how to use it.

---

### Unit specs

I got my devices (I think mine are T6713) from [AliExpress](https://www.aliexpress.com/item/32322544929.html?spm=a2g0s.9042311.0.0.7fcf4c4dwbubog), and there are specs on the page there, but some interesting specs to highlight would be:

|
------------------|-----------------
**Measurement Range** | 0 to 5000 ppm
**Accuracy** | 400-5000 ppm ± 75 ppm or 10% of reading, whichever is greater
**Signal Update** | Every 5 second
**Response Time** | < 3 minutes for 90% step change typical
**Warm Up Time** | < 2 minutes (operational), 10 minutes (maximum accuracy)
**Connection** | I²C slave up to 100 kHz, UART @ 19200 Baud w/Modbus support
**Power Requirements** | 4.5-5.5 VDC, Peak 200mA (155mA typical), Average 25mA (20mA typical)

This sensor is likely good enough for most home uses like just ensuring you're getting enough fresh air during the day, and this is what I'm using it for:

![graph of CO₂ data](images/graph.png#full)

There is more data available on [the datasheet](files/Manual-AMP-0002-T6713-Sensor.pdf).

### Connecting it up

I'm using it connected to an [I²C bus](https://en.wikipedia.org/wiki/I%C2%B2C) on my Raspberry Pi 4, so although there are a few modes of connecting the sensor that's the one I'm focussing on. To do this. I connected the pins as follows:

![T67XX CO₂ sensor datasheet cover](images/connections.png#right)

Pin   | Function | Raspberry Pi 4 pin
------|----------|-----------------
**1** | SDA | 3
**2** | SCL | 5
**3** | V++ | 4
**4** | GND | 6
**5** | PWM | Not connected
**6** | CTRL/TEST | 6 (Also GND)

Whatever you do, don't connect them backwards as this sensor seems to be particularly sensitive to being misconnected (I did this and accidentally let the magic smoke out of one of them). I used a [level shifter](https://www.adafruit.com/product/757) to switch the 3.3v lines to 5v because I didn't have any 4.7k resistors and this is what worked for me, though the unit should work at 3.3v, from the datasheet:

> There is an internal pull up resistor on pin 1 of the I2C interface. Customer will need to provide an external pull up resistor on pin 2 with a recommended value of 4.7k. I2C interface can operate at both 3.3V and 5V logic levels.

![The sensor connected and displaying the CO₂ reading on an LCD](images/connected.jpg#full)

## Using the sensor with the T67XX Go library

I'm not going to go into the details of how the library works, there are docs and examples over at [the T67XX Github page](https://github.com/wjessop/T67XX), but at a high level, given a connection to the I²C bus it can read CO₂ data and perform management tasks. Here's a simple program that waits for the sensor to achieve full accuracy then reads CO₂ values from it every 10 seconds:

```go
package main

import (
	"log"
	"os"
	"time"

	"github.com/wjessop/t67xx"
	"golang.org/x/exp/io/i2c"
)

const (
	// We can change the sensor address on the bus if we want to, but it defaults
	// to 0x21
	t67XXSensorAddress = 0x21
)

func main() {
	// Open an i2c bus that we can pass to the driver
	device, err := i2c.Open(&i2c.Devfs{Dev: "/dev/i2c-1"}, t67XXSensorAddress)
	if err != nil {
		log.Fatalf("Couldn't open the T67XX sensor at %x, error was %v", t67XXSensorAddress, err)
	}

	// Create the driver
	driver := &t67xx.T67XX{}
	driver.Device = device

	// For now the library needs a logger to be provided. It needs to satisfy the
	// following interface:
	//
	// type Logger interface {
	// 	Debug(...interface{})
	// 	Debugf(string, ...interface{})
	// 	Fatalf(string, ...interface{})
	// }
	log := log.New(os.Stderr, "T67XX", log.LstdFlags)
	driver.SetLogger(log)

	// EnableABC enables the ABC calibration. From the datasheet:
	//
	//   "ABC LOGIC™ Automatic Background Logic, or ABC Logic™, is a patented
	//    self-calibration technique that is designed to be used in applications where
	//    concentrations will drop to outside ambient conditions (400 ppm) at least
	//    three times in a 7 days, typically during unoccupied periods. Full accuracy
	//    to be achieved utilizing ABC Logic™. With ABC Logic™ enabled, the sensor will
	//    typically reach its operational accuracy after 24 hours of continuous
	//    operation at a condition that it was exposed to ambient reference levels of
	//    air at 400 ppm CO2. Sensor will maintain accuracy specifications with ABC
	//    Logic™ enabled, given that it is at least four times in 21 days exposed to
	//    the reference value and this reference value is the lowest concentration
	//    to which the sensor is exposed. ABC Logic™ requires continuous operation of
	//    the sensor for periods of at least 24 hours.
	//
	//    Note: Applies when used in typical residential ambient air. Consult Telaire
	//    if other gases or corrosive agents are part of the application environment."
	if err := driver.EnableABC(); err != nil {
		log.Fatal("Could not enable ABC calibration on the sensor", err)
	}

	// Create a signal channel that will be closed when the sensor reaches full accuracy
	accuracyChan := make(chan interface{})

	go func(driver *t67xx.T67XX) {
		// Sleep in the background until the sensor has been powered up long enough
		// to achieve full accuracy.
		err := driver.SleepUntilFullAccuracy()
		if err != nil {
			log.Fatal("Error sleeping until full accuracy", err)
		}

		// Close the signal channel then exit the goroutine as we no-longer need it.
		close(accuracyChan)
	}(driver)

	// Now we can read the CO₂ readings in a loop, taking care to discard any
	// spurious readings.
	for {
		select {
		case <-accuracyChan:
			// A successful read on the closed channel indicates that the sensor is
			// now fully accurate.
			co2Reading, err := driver.GasPPM()
			if err != nil {
				log.Fatal(err)
			}

			// The sensors I have sometimes give spurious readings. Let's discount them.
			// Adjust these values based on the baseline CO₂ reading you expect. The max is
			// the measurement limit according to the datasheet, but i've seen values well
			// over 10,000.
			if co2Reading > 5000 || co2Reading < 200 {
				log.Printf("Reading of %d from CO₂ sensor was out of allowed bounds", co2Reading)
			} else {
				log.Printf("Got CO₂ reading of %d from CO₂ sensor", co2Reading)
			}
		default:
			log.Print("Skipping CO₂ reading as the sensor has not yet achieved full accuracy")
		}

		time.Sleep(10)
	}
}
```

That's it! There's a few more functions that the library provides, such as enabling calibration and setting the I²C bus address, you can check them out at the repo.
