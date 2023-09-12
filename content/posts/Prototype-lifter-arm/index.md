---
title: Prototype lifter arm
date: 2013-11-02T22:04:05
draft: false
tags: [robotics, electronics, tech]
summary: I test the prototype robot ping-pong ball lifter arm and design a new motor driver circuit.
category: ""
type: Post
---

I added a prototype lifter arm to my robot yesterday. It needs re-doing (it's unreliable and heavy) but it works for now.

I'm using a new motor driver circuit for it as I burned out the SN754410 motor driver I was using, the lifter motor seems to peak briefly at about 1.5 amps when starting to lift the arm, and that's out of the chips range. I stayed up late making a new motor control circuit with a L298N that can provide a lot more power.

Here is the robot picking up 12 ping-pong balls. I was driving, Morwenna was filming:

{{< youtube doxEBi1UjLg >}}

Here is the same run seen through the on-board camera. Almost all of the run was done watching the live feed rather than watching the robot itself:

{{< youtube T1NwjBEUjio >}}

Here is the paper strip-board design for the L298N circuit.

{{< figure src="http://willjessop4.files.wordpress.com/2013/11/img_4442.jpg" title="Designing tHe motor driver circuit for stripboard" class="full" alt="Designing tHe motor driver circuit for stripboard">}}

Testing the circuit out on breadboard:

{{< figure src="http://willjessop4.files.wordpress.com/2013/11/img_4440.jpg" title="Wire everywhere, as often happens when I'm doing electronics projects" class="full" alt="A mess of wires and breadboard and stripboard">}}

{{< figure src="http://willjessop4.files.wordpress.com/2013/11/img_4441.jpg" title="The finished circuit. You can see it bolted to the back of the robot in the video." class="full" alt="A finished circuit on stripbord">}}
