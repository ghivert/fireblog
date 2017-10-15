port module Main exposing (..)

import Navigation exposing (Location)
import Html exposing (Html)
import Html.Attributes
import Html.Extra
import Update.Extra as Update
import Update.Extra.Infix exposing (..)
import Window
import Date exposing (Date)
import Task
import Json.Decode as Decode

import Types exposing (..)
import Article
import Article.Decoder
import User.Decoder
import Routing
import View.Home
import View.Article
import View.Contact
import View.Login
import View.Static.Header
import View.Static.Footer
import View.Static.NotFound
import View.Static.About

port requestPosts : String -> Cmd msg
port getPosts : (Decode.Value -> msg) -> Sub msg
port signInUser : (String, String) -> Cmd msg
port logoutUser : String -> Cmd msg
port redirectToDashboard : (Decode.Value -> msg) -> Sub msg

main : Program Never Model Msg
main =
  Navigation.program (Navigation << NewLocation)
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Window.resizes Resizes
    , getPosts GetPosts
    , redirectToDashboard GetUser
    ]

init : Location -> (Model, Cmd Msg)
init location =
  { location = location
  , route = Routing.parseLocation location
  , articles = []
  , menuOpen = False
  , contactFields =
    { email = ""
    , message = ""
    }
  , loginFields =
    { email = ""
    , password = ""
    }
  , user = Nothing
  } ! [ Task.perform DateNow Date.now, requestPosts "myself" ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg ({ menuOpen } as model) =
  case msg of
    Navigation navigation ->
      handleNavigation navigation model
    HamburgerMenu action ->
      handleHamburgerMenu action model
    Resizes { width } ->
      if width >= 736 then
        model
          |> closeMenu
          |> Update.identity
      else
        model ! []
    DateNow date ->
      model ! []
    ContactForm action ->
      handleContactForm action model
    LoginForm action ->
      handleLoginForm action model
    GetPosts posts ->
      posts
        |> Decode.decodeValue Article.Decoder.decodePosts
        |> Result.withDefault []
        |> List.map Article.toUnifiedArticle
        |> setArticlesIn model
        |> Update.identity
    GetUser user ->
      user
        |> Decode.decodeValue User.Decoder.decodeUser
        |> Result.toMaybe
        |> setUserIn model
        |> redirectIfLogin

handleNavigation : SpaNavigation -> Model -> (Model, Cmd Msg)
handleNavigation navigation model =
  case navigation of
    NewLocation location ->
      model
        |> setLocation location
        |> setRoute (Routing.parseLocation location)
        |> Update.identity
    ReloadHomePage ->
      model ! [ Navigation.newUrl "/" ]
    ChangePage url ->
      (closeMenu model) ! [ Navigation.newUrl url ]
    BackPage ->
      model ! [ Navigation.back 1 ]
    ForwardPage ->
      model ! [ Navigation.forward 1 ]

handleHamburgerMenu : MenuAction -> Model -> (Model, Cmd Msg)
handleHamburgerMenu action model =
  case action of
    ToggleMenu ->
      toggleMenu model ! []

handleContactForm : ContactAction -> Model -> (Model, Cmd Msg)
handleContactForm contactAction model =
  case contactAction of
    SendContactMail ->
      model ! []
    ContactEmailInput email ->
      model
        |> setEmailContact email
        |> Update.identity
    ContactMessageInput message ->
      model
        |> setMessageContact message
        |> Update.identity

handleLoginForm : LoginAction -> Model -> (Model, Cmd Msg)
handleLoginForm loginAction ({ loginFields, user } as model) =
  case loginAction of
    LoginUser ->
      model ! [ signInUser (loginFields.email, loginFields.password) ]
    LogoutUser ->
      case user of
        Just { email } ->
          model
            |> setUser Nothing
            |> Update.identity
            |> Update.addCmd (logoutUser email)
            :> handleNavigation (ChangePage "/")
        Nothing ->
          model ! [ Navigation.newUrl "/" ]
    LoginEmailInput email ->
      model
        |> setEmailLogin email
        |> Update.identity
    LoginPasswordInput password ->
      model
        |> setPasswordLogin password
        |> Update.identity

redirectIfLogin : Model -> (Model, Cmd Msg)
redirectIfLogin ({ user, route } as model) =
  model ! [ selectRedirectPath model ]

selectRedirectPath : Model -> Cmd Msg
selectRedirectPath { user, route } =
  case user of
    Nothing ->
      Cmd.none
    Just _ ->
      case route of
        Login ->
          Navigation.newUrl "/dashboard"
        _ ->
          Cmd.none

view : Model -> Html Msg
view model =
  Html.div []
    [ View.Static.Header.view model
    , Html.div
      [ Html.Attributes.class "body" ]
      [ Html.img
        [ Html.Attributes.class "banner-photo"
        , Html.Attributes.src "/static/img/banner-photo.jpg"
        ]
        []
      , Html.div
        [ Html.Attributes.class "container" ]
        [ customView model ]
      ]
    , View.Static.Footer.view model
    ]

customView : Model -> Html Msg
customView ({ route } as model) =
  case route of
    Home ->
      View.Home.view model
    About ->
      View.Static.About.view model
    Article id ->
      model
        |> getArticleById id
        |> Maybe.map View.Article.view
        |> Maybe.withDefault (View.Static.NotFound.view model)
    Archives ->
      Html.Extra.none
    Contact ->
      View.Contact.view model
    Dashboard ->
      Html.Extra.none
    Login ->
      View.Login.view model
    NotFound ->
      View.Static.NotFound.view model
