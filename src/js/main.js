import 'normalize-css'
import hljs from 'highlight.js'
import pako from 'pako'
import * as Post from '@/js/post'
import { Elm } from '@/elm/Main'
import '@/js/config'
import 'highlight.js/styles/atom-one-dark'
import firebase from 'firebase/app'
import 'firebase/auth'
import 'firebase/database'
import '@/styles.css'
import 'hamburgers/dist/hamburgers.css'

window.hljs = hljs
hljs.initHighlightingOnLoad()

// Inject bundled Elm app into div#main.
const program = Elm.Main.init({
  node: document.getElementById('main'),
})

const REQUEST_POSTS = 'REQUEST_POSTS'
const CREATE_POST = 'CREATE_POST'
const UPDATE_POST = 'UPDATE_POST'
const SIGNIN_USER = 'SIGNIN_USER'
const LOGOUT_USER = 'LOGOUT_USER'
const SAVE_TO_LOCAL_STORAGE = 'SAVE_TO_LOCAL_STORAGE'
const CHANGE_STRUCTURED_DATA = 'CHANGE_STRUCTURED_DATA'
const CHANGE_OPEN_GRAPH_DATA = 'CHANGE_OPEN_GRAPH_DATA'
const READ_FROM_LOCAL_STORAGE = 'READ_FROM_LOCAL_STORAGE'
const AUTH_CHANGED = 'AUTH_CHANGED'

const requestPosts = async username => {
  const posts = await Post.list(username)
  return { posts: posts.val() }
}

const createPost = async (username, post) => {
  try {
    await Post.create(username, post)
    return { res: true }
  } catch (error) {
    console.log(error.code)
    console.log(error.message)
    return { res: false }
  }
}

const updatePost = async (username, post) => {
  try {
    await Post.update(username, post)
    return { res: true }
  } catch (error) {
    console.log(error.code)
    console.log(error.message)
    return { res: false }
  }
}

const signInUser = async (email, password) => {
  try {
    await firebase.auth().signInWithEmailAndPassword(mail, password)
  } catch (error) {
    console.log(error.code)
    console.log(error.message)
  } finally {
    return null
  }
}

const logoutUser = async () => {
  await firebase.auth().signOut()
  console.log('Successfully logout!')
  return null
}

const saveToLocalStorage = articles => {
  const deflated = pako.deflate(articles, { to: 'string' })
  window.localStorage.setItem('articles', deflated)
  return { res: true }
}

const changeStructuredData = structuredData => {
  const structuredDataNode = document.getElementById('structured-data')
  structuredDataNode.textContent = JSON.stringify(structuredData)
  return null
}

const changeOpenGraphData = openGraphData => {
  const ogNodes = [...document.getElementsByName('open-graph-nodes')]
  ogNodes.forEach(element => element.remove())
  const head = document.getElementsByTagName('head')[0]
  Object.entries(openGraphData).forEach(([element, content]) => {
    var meta = document.createElement('meta')
    meta.setAttribute('property', 'og:' + element)
    meta.setAttribute('content', content)
    meta.setAttribute('name', 'open-graph-nodes')
    head.appendChild(meta)
  })
  return null
}

const readFromLocalStorage = () => {
  const deflated = window.localStorage.getItem('articles')
  if (deflated !== null) {
    const articles = pako.inflate(deflated, { to: 'string' })
    return { articles }
  }
}

const reduce = async action => {
  switch (action.type) {
    case REQUEST_POSTS: return requestPosts(action.username)
    case CREATE_POST: return createPost(action.username, action.post)
    case UPDATE_POST: return updatePost(action.username, action.post)
    case SIGNIN_USER: return signInUser(action.email, action.password)
    case LOGOUT_USER: return logoutUser()
    case SAVE_TO_LOCAL_STORAGE: return saveToLocalStorage(action.model)
    case CHANGE_STRUCTURED_DATA: return changeStructuredData(action.structuredData)
    case CHANGE_OPEN_GRAPH_DATA: return changeOpenGraphData(action.openGraphData)
    case READ_FROM_LOCAL_STORAGE: return readFromLocalStorage()
    case AUTH_CHANGED: return action
  }
}

const update = async action => {
  const result = await reduce(action)
  if (result !== null) {
    program.ports.fromJS.send({ type: action.type, ...result })
  }
}

const startup = () => {
  program.ports.toJS.subscribe(action => update(action))
  firebase.auth().onAuthStateChanged(user => update({ type: AUTH_CHANGED, user }))
  update({ type: READ_FROM_LOCAL_STORAGE })
}

startup()
