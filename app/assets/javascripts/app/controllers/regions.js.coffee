$ = jQuery.sub()
Region = App.Region

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Region.find(elementID)

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
    @navigate '/regions', region.id if region

class Edit extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
  
  constructor: ->
    super
    @active (params) ->
      @change(params.id)
      
  change: (id) ->
    @item = Region.find(id)
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

  change: (id) ->
    @item = Region.find(id)
    @render()

  render: ->
    @html @view('regions/show')(@item)

  edit: ->
    @navigate '/regions', @item.id, 'edit'

  back: ->
    @navigate '/regions'

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
    @navigate '/regions', item.id, 'edit'
    
  destroy: (e) ->
    item = $(e.target).item()
    item.destroy() if confirm('Sure?')
    
  show: (e) ->
    item = $(e.target).item()
    @navigate '/regions', item.id
    
  new: ->
    @navigate '/regions/new'
    
class App.Regions extends Spine.Stack
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
