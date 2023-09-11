---
title: Full-height Github "checks" box in Firefox
date: 2022-08-16T12:00:00Z
draft: false
tags: ["github", "programming", "firefox"]
summary: No more scolling the checks box on Github when you have plenty of screen space to display it
category: ""
type: Post
---

The scrolling checks box on Github __really__ irritates me. Follow these instructions to make it full height on Firefox.

## 1. Take this CSS:

```css
.branch-action-item.open > .merge-status-list-wrapper > .merge-status-list, .branch-action-item.open > .merge-status-list {
  max-height: fit-content !important;
}
```

## 2. Tell Firefox to use the new CSS

Follow the guide [here](https://davidwalsh.name/firefox-user-stylesheet) for adding it to the custom CSS. And done, full height checks box!

{{< figure src="images/full-height-github-checks-box.png" alt="Notifications in action in Apple Mail" class="full" >}}
