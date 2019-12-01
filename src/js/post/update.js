import * as firebase from 'firebase'

export default function update(user, content) {
  var database = firebase.database()
  var updates = {}

  // update(usercontent) updates an entry using content as content node.
  updates['/user/' + user + '/posts/' + content.uuid + '/title'] = content.title
  updates['/user/' + user + '/posts/' + content.uuid + '/content'] = content.content
  return firebase.database().ref().update(updates)
}
