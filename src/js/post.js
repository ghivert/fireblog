import create from './post/create'
import list from './post/list'

// Record containing all Posts related functions. Will be extended in near
// future when new features are added.
const Post = {
  create: create,
  list: list
}

export default Post;
