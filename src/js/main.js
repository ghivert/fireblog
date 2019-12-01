import 'normalize-css'
import hljs from 'highlight.js'
import pako from 'pako'
import Post from '@/js/post'
import { Elm } from '@/elm/Main'
import '@/js/config'
import firebase from 'firebase'

window.hljs = hljs
hljs.initHighlightingOnLoad()
// Inject bundled Elm app into div#main.
const program = Elm.Main.init({
  node: document.getElementById('main'),
})

// Posts part.
program.ports.requestPosts.subscribe(async userName => {
  console.log('Request posts!')
  const posts = await Post.list(userName)
  program.ports.requestedPosts.send(posts.val())
})

program.ports.createPost.subscribe(async userNameAndPost => {
  try {
    await Post.create(userNameAndPost[0], userNameAndPost[1])
    program.ports.createdPost.send(true)
  } catch (error) {
    console.log(error.code)
    console.log(error.message)
    program.ports.createdPost.send(false)
  }
})

program.ports.updatePost.subscribe(async userNameAndPost => {
  try {
    await Post.update(userNameAndPost[0], userNameAndPost[1])
    program.ports.updatedPost.send(true)
  } catch (error) {
    console.log(error.code)
    console.log(error.message)
    program.ports.updatedPost.send(false)
  }
})

// Authentication part.
program.ports.signInUser.subscribe(async mailAndPassword => {
  try {
    await firebase
      .auth()
      .signInWithEmailAndPassword(mailAndPassword[0], mailAndPassword[1])
  } catch (error) {
    console.log(error.code)
    console.log(error.message)
  }
})

program.ports.logoutUser.subscribe(async email => {
  await firebase.auth().signOut()
  console.log('Successfully logout!')
})

program.ports.changeTitle.subscribe(title => {
  document.title = title
})

program.ports.localStorage.subscribe(articles => {
  const deflated = pako.deflate(articles, { to: 'string' })
  window.localStorage.setItem('articles', deflated)
})

program.ports.changeStructuredData.subscribe(structuredData => {
  const structuredDataNode = document.getElementById('structured-data')
  structuredDataNode.textContent = JSON.stringify(structuredData)
})

program.ports.changeOpenGraphData.subscribe(openGraphData => {
  Array.prototype.slice
    .call(document.getElementsByName('open-graph-nodes'))
    .forEach(element => element.remove())
  const head = document.getElementsByTagName('head')[0]
  Object.keys(openGraphData).forEach(element => {
    var meta = document.createElement('meta')
    meta.setAttribute('property', 'og:' + element)
    meta.setAttribute('content', openGraphData[element])
    meta.setAttribute('name', 'open-graph-nodes')
    head.appendChild(meta)
  })
})

const startup = () => {
  const articles = window.localStorage.getItem('articles')
  if (articles !== null) {
    const inflated = pako.inflate(articles, { to: 'string' })
    program.ports.fromLocalStorage.send(inflated)
  }
}

startup()

firebase.auth().onAuthStateChanged(user => {
  if (user) {
    program.ports.authChanges.send(user)
  } else {
    program.ports.authChanges.send({ disconnected: true })
  }
})
