---
title: "Using the T67XX CO₂ Sensor Module in Go"
summary: Getting CO₂ readings and more from the T67XX CO2 Sensor Module in Go
date: 2020-07-22T22:27:50+01:00
draft: true
tags: ["electronics", "raspberrypi", "golang"]
category: ""
outputs:
- html
- rss
---

![T67XX CO₂ sensor datasheet cover](/img/posts/T67XX.png#right)

So, you bought four T67XX CO₂ sensors and only once they were delivered started to work out how to get values from them huh? Well I'm right there with you, and so I did, and I carefully deposited the results in a new Go lib. Announcing the [Go T67XX CO₂ sensor library](https://github.com/wjessop/T67XX)! This post will give you some details about what these sensors can do, then introduce the library and how to use it.

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
**Digital** | I2C slave up to 100 kHz, UART @ 19200 Baud w/Modbus support
**Power Supply Requirements** | 4.5-5.5 VDC, Peak 200mA (155mA typical), Average 25mA (20mA typical)

In short, this sensor is likely good enough for most home uses like just ensuring you're getting enough fresh air during the day, and the I²C bus makes it easy to pull data off it.

There is also more data available on [the datasheet](/pdf/posts/Manual-AMP-0002-T6713-Sensor.pdf).

### Using the sensor with the T67XX Go library

I'm not going to go into the details of how the library works, it would make for a pretty dull post, and if you want to know that you can just go and look at [the code](https://github.com/wjessop/T67XX), but at a high level