import 'normalize-css'
import './styles/main.scss'
import uuid from 'uuid'
import Post from '../js/post'
import Elm from '../elm/Main'
import '../js/config'

// Inject bundled Elm app into div#main.
const program = Elm.Main.embed(document.getElementById('main'))

program.ports.requestPosts.subscribe(function(userName) {
  Post.list(userName).then(function(posts) {
    program.ports.getPosts.send(posts.val())
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

program.ports.signInUser.subscribe(function(mailAndPassword) {
  firebase.auth().signInWithEmailAndPassword(mailAndPassword[0], mailAndPassword[1]).catch(function(error) {
    console.log(error.code)
    console.log(error.message)
  })
})

firebase.auth().onAuthStateChanged(function(user) {
  if (user) {
    program.ports.redirectToDashboard.send(user)
  }
})

program.ports.logoutUser.subscribe(function(email) {
  firebase.auth().signOut().then(function() {
    console.log('Successfully logout')
  })
})
