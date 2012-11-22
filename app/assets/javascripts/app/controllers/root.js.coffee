$ = jQuery.sub()
World = App.World

class App.Controller.Root extends Spine.Stack
  controllers:
    loading: App.Controller.Loading
    worldsShow:  App.Controller.Worlds.Show
    worldsIndex:  App.Controller.Worlds.Index

  routes:
    '/':                'loading'
    '/worlds':          'worldsIndex'
    '/worlds/:id':      'worldsShow'

  default: 'loading'
  className: 'stack root'
