export default function list(user) {
  var database = firebase.database()

  return database.ref('user/' + user + '/posts').once('value')
}
