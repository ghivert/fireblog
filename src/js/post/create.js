import uuid from 'uuid'

export default function create(user, title, content) {
  var database = firebase.database()

  database.ref('user/' + user + '/post').set({
    title: title,
    content: content
  })
}
