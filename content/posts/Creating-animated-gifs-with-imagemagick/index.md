---
title: Creating animated gifs with imagemagick
date: 2012-04-24T10:49:42Z
draft: false
tags: [tech]
summary: An example command line command to create animated gifs with imagemagick
category: ""
type: Post
---

In [my last post](/posts/railsberry-animated-gifs "Railsberry animated gifs") I linked to some animated gifs I made on my mac. It's pretty easy if you have imagemagick installed.

Simply get a bunch of images together and use the convert command:

	convert -resize 900x -loop 0 -delay 10 DSC_8264.JPG DSC_8265.JPG DSC_8266.JPG DSC_8267.JPG DSC_8268.JPG DSC_8269.JPG DSC_8270.JPG jon_walk.gif

The last argument is the output filename. The options should be self explanatory, but you can check them up in the man page if you want to tweak the values.
