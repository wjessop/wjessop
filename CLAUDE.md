# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Will Jessop's personal blog (https://willj.net), built with Hugo (extended, installed via Homebrew). The theme is entirely custom, living in `layouts/` and `assets/sass/styles.scss` — there is no `themes/` directory.

## Commands

- `make server` — local dev server (`hugo server -DF`: renders drafts and future-dated posts)
- `make remote-server` — dev server bound to 0.0.0.0 for viewing from other devices on the LAN
- `make` (or `make all`) — build the site into `docs/`

## Deployment

GitHub Pages serves the site from the committed `docs/` directory on `master`. Deploying a change means: run `make`, then commit both the source change and the regenerated `docs/` output, and push. The generated `docs/` files belong in the same commit as the content/layout change that produced them.

## Content structure

- Posts are page bundles: `content/posts/<Post-Name>/index.md`, with images in an `images/` subdirectory of the bundle. The directory name (hyphenated, usually Title-Case) becomes the URL slug. A few older posts are flat `.md` files.
- New posts should use the `archetypes/posts.md` archetype (e.g. `hugo new posts/My-Post/index.md`).
- `content/scratch/` holds non-post pages; `content/about/hire-me/` is intentionally excluded from robots.txt.
- `old_article_archive/` and `Original wp blog exports/` are gitignored artifacts of the original WordPress → Hugo migration; ignore them.

## Front matter conventions

- `type: Post` — the homepage (`layouts/index.html`) only lists pages with this type; omit it and the post won't appear there.
- `preview: true` — the page builds (so the URL can be shared for review) but is excluded from the homepage, section lists, RSS, and the sitemap. Used together with `draft: true` for work in progress; remove both to publish.
- `opentocontracts: false` — suppresses the site-wide "open to contracts" banner (enabled globally via `params.OpenToContracts` in `config.toml`) on a single page.
- Old-URL redirects from the WordPress era are handled with Hugo `aliases` in front matter.

## Layout notes

- RSS is renamed from Hugo's default `index.xml` to `rss.xml` (`outputFormats.RSS.baseName` in `config.toml`) and is only generated for the home page.
- List templates, RSS, and the sitemap all filter on `Params.preview != true` — any new list-like template must apply the same filter or preview posts will leak.
