import firebase from 'firebase/app'

const create = (user, content) => {
  // push(content) creates a new entry with a hash depending on time,
  // using content as content node. It does not override present content,
  // ensuring nothing will never be erased.
  return database
    .ref(`user/${user}/posts`)
    .push({ ...content, date: new Date(Date.now()).toISOString() })
}

const list = user => {
  console.log("List posts!")
  // List the posts once. It does not uses on, for SPA appearance reason.
  // Refreshing should be triggered by the user, to avoid distraction of
  // new items popping on the screen.
  return firebase.database().ref(`user/${user}/posts`).once('value')
}

const update = (user, { title, content, uuid }) => {
  const update = { title, content }
  const ref = `/user/${user}/posts/${uuid}/title`
  return firebase.database().ref(ref).update(content)
}

export { create, list, update }
