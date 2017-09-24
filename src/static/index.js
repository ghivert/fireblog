import 'normalize-css'
import './styles/main.scss'
import Elm from '../elm/Main'

// Inject bundled Elm app into div#main.
Elm.Main.embed(document.getElementById('main'))
