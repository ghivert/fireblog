import 'normalize-css'
import './styles/main.scss'
import Post from '../js/post'
import Elm from '../elm/Main'
import '../js/config'

// Inject bundled Elm app into div#main.
const program = Elm.Main.embed(document.getElementById('main'))

// Posts part.
program.ports.requestPosts.subscribe(function(userName) {
  console.log("Request posts!")
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

// Authentication part.
program.ports.signInUser.subscribe(function(mailAndPassword) {
  firebase.auth().signInWithEmailAndPassword(mailAndPassword[0], mailAndPassword[1]).catch(function(error) {
    console.log(error.code)
    console.log(error.message)
  })
})

program.ports.logoutUser.subscribe(function(email) {
  firebase.auth().signOut().then(function() {
    console.log('Successfully logout!')
  })
})

firebase.auth().onAuthStateChanged(function(user) {
  if (user) {
    program.ports.authChanges.send(user)
  } else {
    program.ports.authChanges.send({disconnected: true})
  }
})
