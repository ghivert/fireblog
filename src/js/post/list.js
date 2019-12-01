import * as firebase from 'firebase'

const list = user => {
  console.log("List posts!")
  // List the posts once. It does not uses on, for SPA appearance reason.
  // Refreshing should be triggered by the user, to avoid distraction of
  // new items popping on the screen.
  return firebase.database().ref(`user/${user}/posts`).once('value')
}

export default list
