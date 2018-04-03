import create from './post/create'
import list from './post/list'
import update from './post/update'

// Record containing all Posts related functions. Will be extended in near
// future when new features are added.
const Post = {
  create: create,
  list: list,
  update: update
}

export default Post;
