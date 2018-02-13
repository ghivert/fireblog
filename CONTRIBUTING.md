# Contributing to Personal Blog

First, thanks for your interest!

Here are the guidelines for contributing:

- Respect the elm spacing. I know I'm using 2 spaces indent (which does not respect elm-format), but it's my choice. I'm not forcing you to daily code with 2 spaces, don't force me to daily code with elm-format. If you think this point is too constraining, please, just give up. I won't change my mind, so don't try to make me change. 😁
- Do not use native packages in elm. It's complicated and painful to link a native package (with elm-install or grove), and not accessible for any beginner. If you really want a feature which is not available in elm-packages today, put pressure on elm-community to get your feature published! 😉
- One JS file should contain one export in general. Exceptions exists, like `index.js`, but try to stick with one export by file, like for Posts.
- Do not link JavaScript library in `index.html`. It's ugly and a bad practice. Just install it with `yarn`, and use it in your JavaScript with `require` or `import`. Webpack is here for this, and it's really simpler to get updates like this.
- You want to contribute, but don't know how? Write some docs! It's really helpful, and we always miss docs!
