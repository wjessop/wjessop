---
title: First robot remote driving test
date: 2013-11-01T02:16:09
draft: false
tags: [tech, robotics, electronics, 3D Printing]
summary: I control my robot remotely for the first time.
category: ""
type: Post
---

I programmed some remote control software using a Golang receiving program on the robot and a ruby control client using my [gamepad ruby gem](https://github.com/wjessop/gamepad) and an Xbox 1 controller. It worked OK. It was a bit jerky, there's no PWM so no acceleration, it's either go or stop; anything not totally rigid on the robot wobbles. Also the position of the camera doesn't show enough of the robot so it's hard to get a real idea of where the robot is.

I was filming, the robot was being controlled my my wife, Morwenna, from upstairs.

{{< youtube 4YYC7bCiRTI >}}

The robot is also prone to shed a track if the "half turn" is used too much, that is one track forwards or backwards, the other one stationary. I can fix this in software if I can work out a way to do PWM on the robot that doesn't run the Raspberry Pi CPU.
