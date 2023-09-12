---
title: Testing the new battery + lifter arm circuit
date: 2013-10-28T23:02:01
draft: false
tags: [robotics, electronics, tech, Raspberry Pi]
summary: Running the robot circuitry off a battery for the first time.
category: ""
type: Post
---

First test of the Raspberry Pi running off battery power with no external supply at all. In the picture the 5000mAh battery is the object at the back with "5000" written on it. My multimeter is measuring the voltage output. One of the Raspberry Pi (the thing with the red light on it) output pins is connected through the MotorPiTX board (the yellow circuit board on-top of the Raspberry Pi) to the breadboard.

The breadboard contains two circuits, the top-right cluster of components is the circuit that turns the output of the Raspberry Pi into something relevant to the motor driver in the bottom left, the bottom left cluster of components is the motor driver itself.

The Pi is pulsing the output causing the motor driver to spin the motor. The micro-switch just on the very bottom of the picture is one of the limit switches for the ball lifter arm.

{{< figure src="images/img_4418.jpg" title="A relatively tidy electronics bench for once" class="full" alt="A curcuit under test with a multimeter">}}
