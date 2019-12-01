import * as firebase from 'firebase'

const create = (user, content) => {
  // push(content) creates a new entry with a hash depending on time,
  // using content as content node. It does not override present content,
  // ensuring nothing will never be erased.
  return database
    .ref(`user/${user}/posts`)
    .push({ ...content, date: new Date(Date.now()).toISOString() })
}

export default create
