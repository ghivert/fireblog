import * as firebase from 'firebase'

const update = (user, { title, content, uuid }) => {
  const update = { title, content }
  const ref = `/user/${user}/posts/${uuid}/title`
  return firebase.database().ref(ref).update(content)
}

export default update
