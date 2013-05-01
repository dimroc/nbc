class App.User extends Spine.Model
  isAdmin: =>
    _(@roles).contains("admin")
