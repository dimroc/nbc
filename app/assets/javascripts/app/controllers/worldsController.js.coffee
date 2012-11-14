$ = jQuery.sub()
World = App.World

$.fn.item = ->
  elementID   = $(@).data('slug')
  elementID or= $(@).parents('[data-slug]').data('slug')
  World.findByAttribute("slug", elementID)

class New extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'

  constructor: ->
    super
    @active @render

  render: ->
    @html @view('worlds/new')

  back: ->
    @navigate '/worlds'

  submit: (e) ->
    e.preventDefault()
    world = World.fromForm(e.target).save()
    @navigate '/worlds', world.slug if world

class Edit extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (slug) ->
    @item = World.findByAttribute("slug", slug)
    @render()

  render: ->
    @html @view('worlds/edit')(@item)

  back: ->
    @navigate '/worlds'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/worlds'

class Show extends Spine.Controller
  events:
    'click [data-type=edit]': 'edit'
    'click [data-type=back]': 'back'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (slug) ->
    World.findOrFetch(slug, (world) =>
      @item = world
      @item.fetchRegions => @render()
    )

  render: ->
    output = @html @view('worlds/show')(@item)
    @worldRenderer.attachToDom($(output).find("#world"))
    @worldRenderer.add(@item.meshes())
    @worldRenderer.animate()
    output

  edit: ->
    @navigate '/worlds', @item.slug, 'edit'

  back: ->
    @navigate '/worlds'

  activate: ->
    super
    @worldRenderer = new App.WorldRenderer()

  deactivate: ->
    super
    if @worldRenderer
      @worldRenderer.destroy()
      delete @worldRenderer

    @el.empty()

class Index extends Spine.Controller
  events:
    'click [data-type=edit]':    'edit'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=show]':    'show'
    'click [data-type=new]':     'new'

  constructor: ->
    super
    World.bind 'refresh change', @render
    World.fetch()

  render: =>
    worlds = World.all()
    @html @view('worlds/index')(worlds: worlds)

  edit: (e) ->
    item = $(e.target).item()
    @navigate '/worlds', item.slug, 'edit'

  destroy: (e) ->
    item = $(e.target).item()
    item.destroy() if confirm('Sure?')

  show: (e) ->
    item = $(e.target).item()
    @navigate '/worlds', item.slug

  new: ->
    @navigate '/worlds/new'

class App.WorldsController extends Spine.Stack
  controllers:
    index: Index
    edit:  Edit
    show:  Show
    new:   New

  routes:
    '/worlds/new':      'new'
    '/worlds/:id/edit': 'edit'
    '/worlds/:id':      'show'
    '/worlds':          'index'

  default: 'index'
  className: 'stack worlds'
