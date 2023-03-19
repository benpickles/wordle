# My Wordle results

This is a teeny microsite archive of [my Wordle results](https://www.benpickles.com/wordle/), it's also an example of using [Parklife](https://github.com/benpickles/parklife) to render a Sinatra app to a static build.

The app is a [single route and not much more](https://github.com/benpickles/wordle/blob/main/app.rb). In development run the app with [`bin/dev`](https://github.com/benpickles/wordle/blob/main/bin/dev).

I added Parklife and ran `parklife init --sinatra --github-pages` to generate a [`Parkfile`](https://github.com/benpickles/wordle/blob/main/Parkfile) and a [GitHub Actions workflow to build and push to GitHub Pages](https://github.com/benpickles/wordle/blob/main/.github/workflows/parklife.yml).

I use [Netlify's Rewrites and proxies](https://docs.netlify.com/routing/redirects/rewrites-proxies/) to proxy it from my own site to make it available under my domain using the `netlify.toml` config:

```
[[redirects]]
  from = "/wordle/*"
  to = "https://benpickles.github.io/wordle/:splat"
  status = 200
```
