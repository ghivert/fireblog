import 'normalize-css'
import hljs from 'highlight.js'
import pako from 'pako'
import './styles/main.scss'
import Post from '../js/post'
import Elm from '../elm/Main'
import '../js/config'

window.hljs = hljs
hljs.initHighlightingOnLoad()
// Inject bundled Elm app into div#main.
const program = Elm.Main.embed(document.getElementById('main'))

// Posts part.
program.ports.requestPosts.subscribe(function(userName) {
  console.log("Request posts!")
  Post.list(userName).then(function(posts) {
    program.ports.requestedPosts.send(posts.val())
  })
})

program.ports.createPost.subscribe(function(userNameAndPost) {
  Post.create(userNameAndPost[0], userNameAndPost[1]).then(function() {
    program.ports.createdPost.send(true)
  }).catch(function(error) {
    console.log(error.code)
    console.log(error.message)
    program.ports.createdPost.send(false)
  })
})

// Authentication part.
program.ports.signInUser.subscribe(function(mailAndPassword) {
  firebase.auth()
          .signInWithEmailAndPassword(mailAndPassword[0], mailAndPassword[1])
          .catch(function(error) {
    console.log(error.code)
    console.log(error.message)
  })
})

program.ports.logoutUser.subscribe(function(email) {
  firebase.auth().signOut().then(function() {
    console.log('Successfully logout!')
  })
})

program.ports.changeTitle.subscribe(function(title) {
  document.title = title
})

program.ports.localStorage.subscribe(function(articles) {
  window.localStorage.setItem("articles", pako.deflate(articles, {to: 'string'}))
})

var articles = window.localStorage.getItem("articles")
if (articles !== null) {
  program.ports.fromLocalStorage.send(pako.inflate(articles, {to: 'string'}))
}

firebase.auth().onAuthStateChanged(function(user) {
  if (user) {
    program.ports.authChanges.send(user)
  } else {
    program.ports.authChanges.send({disconnected: true})
  }
})
