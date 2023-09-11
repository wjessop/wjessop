---
title: Reverting Firefox's recent URL bar suggestion order change
date: 2023-09-11T17:27:00+01:00
draft: false
tags: ["tech", "firefox"]
summary: In a recent update Firefox changed the order of it's URL bar suggestions order to make search suggestions appear first before recently visited URLs. This is annoying so I changed it back.
category: ""
type: Post
---

A recent update to Firefox changed the order of suggestions when you started typing in the URL bar (or "address bar"). It used to be that you'd get recently visited URLs first but the change caused search suggestions to appear first. I almost always navigate to sites I know by typing the first few letters of the domain name and almost never used the search suggestions so this change cause consternation.

{{< figure src="images/Before.png" title="The URL bar suggestions after Firefox \"Improved\" the experience in a recent update and changed the suggestions order" class="full" alt="A firefox URL bar suggestions dropdown showing suggested searches before recently visited sites">}}

Fearing for the longevity of my down arrow key caused the wear of all the extra pressing to get down to the recently visited URLs section I searched for a solution. It turns out that you can change the order of the suggestions in the config. To do so:

1. Open a new Firefox tab
2. Type `about:config`
3. Accept any warnings (yolo)
4. Type `browser.urlbar.showSearchSuggestionsFirst` into the search field
5. Toggle the value

You shouldn't need to restart Firefox for the change to take effect, and should now have your URL history back where it was before the search suggestions.

{{< figure src="images/After.png" title="URL bar suggestion order, now fixed" class="full" alt="A firefox URL bar with recently visited sites before search suggestions">}}
