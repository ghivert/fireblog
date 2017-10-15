import 'normalize-css'
import './styles/main.scss'
import uuid from 'uuid'
import Post from '../js/post'
import Elm from '../elm/Main'

var database = firebase.database()

database.ref('user/myself/post').push({
  title: 'Lorem Ipsum',
  content: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
  date: new Date().toString()
})

// database.ref('user/myself').on('value', function(snapshot) {
//   console.log('Inside on')
//   console.log(snapshot.val())
// })

console.log(Post)
console.log(Post.list('myself').then(function(snapshot) {
  console.log(snapshot.val())
}))

// Inject bundled Elm app into div#main.
const program = Elm.Main.embed(document.getElementById('main'))

program.ports.requestPosts.subscribe(function(userName) {
  console.log('beginning')

  Post.list(userName).then(function(posts) {
    console.log('received')
    program.ports.getPosts.send(posts.val())
  })
})
