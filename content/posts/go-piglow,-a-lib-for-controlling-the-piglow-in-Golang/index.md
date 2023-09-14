---
title: go-piglow, a lib for controlling the piglow in Golang
date: 2013-09-03T23:26:43Z
draft: false
tags: [electronics, Raspberry Pi, programming, Go]
summary: A Go library for controlling the Piglow board with example programs.
category: ""
type: Post

---
{{< figure src="images/piglow.jpg" alt="A Piglow Raspberry pi board lit up" title="A Piglow glowing" class="full" >}}

A few days ago I got a [Piglow](http://shop.pimoroni.com/products/piglow "Piglow"). It's a fairly useless but fun addon board for the Raspberry Pi that has 18 individual user controllable LEDs arranged in Arms/Legs/Tentacles (whatever you want to call them).

There are example programs out there to control the LEDs, but they are all in Python, and on my Pi they are all fairly slow so I wrote my own lib for Go: [https://github.com/wjessop/go-piglow](https://github.com/wjessop/go-piglow)

The API is fairly strigthtforward, this sample program just turns on and off some of the LEDS:

```go
package main

import (
    "github.com/wjessop/go-piglow"
    "log"
)

func main() {
    var p *piglow.Piglow
    var err error

    // Create a new Piglow
    p, err = piglow.NewPiglow(); if err != nil {
        log.Fatal("Couldn't create a Piglow: ", err)
    }

    p.SetLED(0, 255) // Set LED 0 to 255 (max brightness)
    p.SetLED(1, 128) // Set LED 1 to half brightness
    err = p.Apply(); if err != nil { // Apply the changes
        log.Fatal("Couldn't apply changes: ", err)
    }
}
```

The lib API allows for controlling individual LEDs, the colour rings, the tentacles, or to display a value bar-graph style on each tentacle.

I wrote some more complex example programs to go with the lib to demo these capabilities. A simple program to flash the LEDs, a CPU meter that displays 1, 5 and 15 minute load average on each of the tentacles, and the most fun, a disco program, here is me demonstrating them:

{{< youtube 1EmJIwzhJwQ >}}

Right now i'm running [this program](https://github.com/wjessop/piglow-fader "piglow-fader") on my Pi to slowly fade between the colour rings.
