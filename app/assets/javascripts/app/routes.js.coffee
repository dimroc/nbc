Controller = App.Controller

getDefaultController = ->
  # Load empty test controller when running jasmine
  if jasmine? then 'test' else 'splash'

class Controller.Root extends Spine.Stack
  controllers:
    test:           Controller.Test
    splash:         Controller.Splash
    boroughs:       Controller.Boroughs
    worldsShow:     Controller.Worlds.Show
    worldsIndex:    Controller.Worlds.Index

  routes:
    '/':                getDefaultController()
    '/boroughs':        'boroughs'
    '/worlds':          'worldsIndex'
    '/worlds/:id':      'worldsShow'

  default: getDefaultController()
  className: 'stack root'
