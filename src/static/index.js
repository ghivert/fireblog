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

program.ports.updatePost.subscribe(function(userNameAndPost) {
  Post.update(userNameAndPost[0], userNameAndPost[1]).then(function() {
    program.ports.updatedPost.send(true)
  }).catch(function(error) {
    console.log(error.code)
    console.log(error.message)
    program.ports.updatedPost.send(false)
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

program.ports.changeStructuredData.subscribe(function(structuredData) {
  const structuredDataNode = document.getElementById("structured-data")
  structuredDataNode.textContent = JSON.stringify(structuredData)
})

program.ports.changeOpenGraphData.subscribe(function(openGraphData) {
  Array.prototype.slice.call(document.getElementsByName("open-graph-nodes"))
    .forEach(function(element) {
      element.remove()
    })
  const head = document.getElementsByTagName("head")[0]
  Object
    .keys(openGraphData)
    .forEach(function(element) {
      var meta = document.createElement("meta")
      meta.setAttribute("property", "og:" + element)
      meta.setAttribute("content", openGraphData[element])
      meta.setAttribute("name", "open-graph-nodes")
      head.appendChild(meta)
    })
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
