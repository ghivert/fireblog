export default function list(user) {
  var database = firebase.database()

  // List the posts once. It does not uses on, for SPA appearance reason.
  // Refreshing should be triggered by the user, to avoid distraction of
  // new items popping on the screen.
  return database.ref('user/' + user + '/posts').once('value')
}
