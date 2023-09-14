---
title: Secret project
date: 2013-09-07T12:41:02Z
draft: false
tags: [robotics, electronics, Raspberry Pi, Go]
summary: Designing a track mount robot, new motors
category: ""
type: Post
---

{{< figure src="images/41c6bjctp2l1.jpg" alt="A very small motor with an in-built gearbox" title="One of my new motors. It's about 10mm in diameter" class="right" >}}

I've started work on a top-secret project. I can't really hide the fact that it's going to be a robot, but I'm not going to say what it is, at least not just yet.

So, last night I was designing a 3d printed mount for the [tiny 3-6V motors](http://www.amazon.co.uk/gp/product/B008OAYP8Q/ref=as_li_ss_tl?ie=UTF8&camp=1634&creative=19450&creativeASIN=B008OAYP8Q&linkCode=as2&tag=will_j-21 "3-6V motors") I bought and I started to wonder if I could cobble something together using my old technic lego. I dug out the lego, but on top of that was my dusty old meccano set, even better!

WIthin a short amount of time I had some motor mounts and a frame made, including tensioning springs for the caterpillar tracks. All that was left was to take it for a spin. I hooked it up to my Raspberry Pi via my Custard Pi breakout board, a [ULN2803A](https://simple.m.wikipedia.org/wiki/File:ULN2803A_Transistor_Array.jpg) and a custom voltage regulator circuit.

{{< figure src="images/img_4248.jpg" alt="A very small motor with an in-built gearbox" title="Motor mount" class="full" >}}

Seeing if it drives in a straight line:

{{< youtube JrhgSdsNkCM >}}

Hooked up to the Raspberry Pi, controlled by microswitches. You can see the top of the Custard Pi poking out over the mess of wires that is my breadboard and the cheap wireless dongle/antenna I got from eBay. The voltage regulator circuit makes an appearance being dragged along behind:

{{< youtube Op8CD11w8OQ >}}

{{< figure src="images/img_4247.jpg" alt="A PCB with no components on it and a bag of componenets" title="MotorPiTX kit" class="full" >}}

Right now it only goes forwards because I didn't have the circuitry for anything else, but I got my MotorPiTX in the mail this morning so that will change soon.
