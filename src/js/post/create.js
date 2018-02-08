import uuid from 'uuid'

export default function create(user, content) {
  var database = firebase.database()

  content.date = new Date(Date.now()).toISOString()

  return database.ref('user/' + user + '/posts').push(content)
}
