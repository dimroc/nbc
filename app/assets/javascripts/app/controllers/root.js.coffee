$ = jQuery.sub()
World = App.World

getDefaultController = ->
  # Load empty test controller when running jasmine
  if jasmine? then App.Controller.Test else App.Controller.Splash

class App.Controller.Root extends Spine.Stack
  controllers:
    splash: getDefaultController()
    worldsShow:  App.Controller.Worlds.Show
    worldsIndex:  App.Controller.Worlds.Index

  routes:
    '/':                'splash'
    '/worlds':          'worldsIndex'
    '/worlds/:id':      'worldsShow'

  default: 'splash'
  className: 'stack root'
