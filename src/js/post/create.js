export default function create(user, content) {
  var database = firebase.database()

  // Fix post date, as it is somewhat complicated in elm, and don't have
  // huge interest.
  content.date = new Date(Date.now()).toISOString()

  // push(content) creates a new entry with a hash depending on time,
  // using content as content node. It does not override present content,
  // ensuring nothing will never be erased.
  return database.ref('user/' + user + '/posts').push(content)
}
