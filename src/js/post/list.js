export default function list(user) {
  var database = firebase.database()

  return database.ref('user/' + user + '/post').once('value')
}
