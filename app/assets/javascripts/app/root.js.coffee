Controller = App.Controller

getDefaultController = ->
  # Load empty test controller when running jasmine
  if jasmine? then 'test' else 'splash'

class Controller.Root extends Spine.Stack
  controllers:
    test:           Controller.Test
    splash:         Controller.Splash
    boroughs:       Controller.Boroughs
    regionsShow:     Controller.Regions.Show
    regionsIndex:    Controller.Regions.Index

  routes:
    '/':                getDefaultController()
    '/boroughs':        'boroughs'
    '/boroughs/:id':    'boroughs'
    '/regions':         'regionsIndex'
    '/regions/:id':     'regionsShow'

  default: getDefaultController()
  className: 'stack root'
