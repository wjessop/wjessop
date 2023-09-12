---
title: Converting a wordpress.com dump to Hugo, including images
date: 2023-09-12T13:30:00+01:00
draft: false
tags: ["programming", "Go", "tech", "Hugo"]
summary: I wanted to convert my old wordpress.com articles to Hugo and all off the "official" methods were cumbersome so I wrote a somewhat rough but fast and simple program to do the conversion for me.
category: ""
type: Post
---

There are a few ["official" options for migrating wordpress content to Hugo](https://gohugo.io/tools/migrations/#wordpress), but they are all either cumbersome (requiring installing wordpress in docker) or don't handle images. I didn't want to spend too much time on this and definitely wanted images to be converted so wrote a quick program to handle the conversion for me.

In the end [I created a somewhat rough, but functional program to do the job](https://github.com/wjessop/wordpress_to_hugo) and it was successful.

The requirements:

- Extracts tags where there are any on the original post and adds them to the front Hugo matter
- Maintains the original post date
- Converts the HTML to Markdown
- Maintains the directory structure, with images copied to the directory that the post's index.md is in:
  ```thing
  basedir/
    content/
      posts/
        Some-post-title/
          index.md
          images/
            post-image-1.jpg
            post-image-2.png
       A-different-post-title/
        index.md
        images/
          post-image-for-this-other-arcicle.jpg
	```

There are some caveats:

- **Posts require some fixup**

	There's a little bit of tweaking that I've had to do to Hugo front matter or the posts, but the program got me mostly all the way. These things could likely be fixed in the code and it would be worth doing so if I was going to run the program more than once, but I'm not so it was faster to fix things up manually.

- **Doesn't write the summary**

	I had to write this manually, but I was only dealiing with 10s of posts. If you want to use this then you might want to add something to generate a summary.

- **Doesn't always get the image URLs right in the markdown (but it's easily fixable)**

	The code left a few images URLs in the posts pointing to the old wordpress site. It still copied over the images so it was a really simple find and replace to fix these up.

- **Doesn't do any error checking, just panics**

	It didn't error so I didn't put in the time to handle errors as it was a one-off program, it worked for me.

- **Skips image only posts**

	This was delberate, but you might want to add that feature.

Anyway, the code got me 90% of the way to where I wanted the posts to get so worked well for what I wanted it to do and I'd call it a success. [I've put the code up on Github](https://github.com/wjessop/wordpress_to_hugo), I likely won't need to run this code again, but if it's useful to you please feel free to submit PRs.
