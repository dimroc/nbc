class App.Controller.UserPanel extends Spine.Controller
  events:
    'click a.login':   'login'

  constructor: ->
    super
    $.when(window.facebookDfd).then(@initialize)

  successfulLoginHandler: (json) =>
    App.current_user = new App.User(json)
    @html(@view('userPanels/loggedIn')(App.current_user))
    console.debug "connected:", JSON.stringify(json)

  facebookSuccessHandler: (response) =>
    if(response.authResponse)
      $("#facebook-connect a").html("Connecting to FB...")
      $.getJSON(
        "/users/auth/facebook/callback",
        { signed_request: response.authResponse.signedRequest },
        @successfulLoginHandler)

  login: (event) ->
    FB.login(@facebookSuccessHandler, scope: "email")

  initialize: =>
    @html(@view('userPanels/loggedOut')())

    FB.getLoginStatus((response) =>
      if response.status is "connected"
        console.debug "Automatically logging in to facebook"
        @facebookSuccessHandler response)

$ ->
  Spine.one "ready", ->
    handler = new App.Controller.UserPanel(el: $("#facebook-connect"))
