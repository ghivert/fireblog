# Fireblog

The world is full of words. Let's add more. Blogging is essential. Having a personal blog is required. Here is one.

## Context

As a complement of Medium (where I'm posting everything in English), I wanted to get a fully working blog in French. Built with elm and Firebase, all of this started as an experimentation to get a valid SPA working with elm and Firebase. With time going through, I thought it would be so cool to let everyone enjoy this, and take inspiration if they want, because it's not always easy to find an example of an SPA in elm in « production ».  
The goal is to provide an easy-way to deploy the application on Firebase, with little or no effort at all, just like WordPress do -- but easier, and only focused on blogging, not all noise around. The focus is put on accessibility, rich web content, single-page application and quality blogging.

## Installation

Creates an account on Firebase, and creates a new project. You will be able to access the integration with JavaScript. Just get something like this:

```javascript
var config = {
  apiKey: "api-key",
  authDomain: "project-url",
  databaseURL: "database-url",
  projectId: "project-name",
  storageBucket: "storage-bucket-url",
  messagingSenderId: "one-random-number"
}
```

When you found it, paste it on `config.js` and replace the standard config (my config). Don't be afraid to share it: it will be on all pages of your site. If someone wants it, can have it really easily.<br>
Enable email authentication, and create your account to authenticate. Finally add the uid of the user to the firebase rules of the database, and you're good to go.

Configuration is done!

## Deployment

You'll need `yarn`. Please, do not use `npm`. You can easily install it with `brew` on macOS, or `npm install -g yarn`.

You'll need Firebase CLI. It's on `npm`. Install it with `npm install -g firebase-tools` or `yarn global add firebase-tools`. Next, use `firebase login` and follow the steps, to get the `firebase` command working.

```bash
# First login to Firebase.
firebase login
# Install the project, build it and deploy it!
yarn  
yarn build  
firebase deploy
```

## Customization

All styling is done in SCSS and resides mostly in `neptune`. Feel free to modify anything to get your favorite styling.  
The elm code producing HTML resides only in `View`. It's really easy to change the content of the views as you can avoid modifying types and logic.  

# I like this project, can I use it and contribute?

Contribution is so good! I would be glad to accept pull requests to improve it and let even more people use it. Of course, you can also use it without contributing! After all, it's free software, you're free to use it as you want.  
There is a contributing guide and a code of conduct, please read them to get an idea on how to do if you want, and be friendly with everyone!
