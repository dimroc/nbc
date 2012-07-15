$ = jQuery.sub()
Region = App.Region

$.fn.item = ->
  elementID   = $(@).data('slug')
  elementID or= $(@).parents('[data-slug]').data('slug')
  Region.findByAttribute("slug", elementID)

class New extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'

  constructor: ->
    super
    @active @render

  render: ->
    @html @view('regions/new')

  back: ->
    @navigate '/regions'

  submit: (e) ->
    e.preventDefault()
    region = Region.fromForm(e.target).save()
    @navigate '/regions', region.slug if region

class Edit extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (slug) ->
    @item = Region.findByAttribute("slug", slug)
    @render()

  render: ->
    @html @view('regions/edit')(@item)

  back: ->
    @navigate '/regions'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/regions'

class Show extends Spine.Controller
  events:
    'click [data-type=edit]': 'edit'
    'click [data-type=back]': 'back'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (slug) ->
    Region.findOrFetch(slug, (region) =>
      @item = region
      @item.fetchBlocks => @render()
    )

  render: ->
    output = @html @view('regions/show')(@item)
    @world.attachToDom(output)

    _.each(@item.blocks().all(), (block) =>
      blockController = new App.BlocksGraphicController(block)
      @world.add(blockController.view)
    )

    @world.animate()
    output

  edit: ->
    @navigate '/regions', @item.slug, 'edit'

  back: ->
    @navigate '/regions'

  activate: ->
    super
    @world = new App.World()

  deactivate: ->
    super
    if @world
      @world.destroy()
      delete @world

    @el.empty()

class Index extends Spine.Controller
  events:
    'click [data-type=edit]':    'edit'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=show]':    'show'
    'click [data-type=new]':     'new'

  constructor: ->
    super
    Region.bind 'refresh change', @render
    Region.fetch()

  render: =>
    regions = Region.all()
    @html @view('regions/index')(regions: regions)

  edit: (e) ->
    item = $(e.target).item()
    @navigate '/regions', item.slug, 'edit'

  destroy: (e) ->
    item = $(e.target).item()
    item.destroy() if confirm('Sure?')

  show: (e) ->
    item = $(e.target).item()
    @navigate '/regions', item.slug

  new: ->
    @navigate '/regions/new'

class App.RegionsController extends Spine.Stack
  controllers:
    index: Index
    edit:  Edit
    show:  Show
    new:   New

  routes:
    '/regions/new':      'new'
    '/regions/:id/edit': 'edit'
    '/regions/:id':      'show'
    '/regions':          'index'

  default: 'index'
  className: 'stack regions'
