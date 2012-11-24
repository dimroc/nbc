class App.Region extends App.Model
  @configure 'Region', 'id', 'name', 'slug', 'current_block'
  @extend Spine.Model.Ajax
  @url: "#{Constants.apiBasePath}/regions"

  @hasMany 'blocks', "App.Block"

  validate: ->
    @errors = {}
    @appendErrors(name: "Name is required") unless @name
    @appendErrors(slug: "slug is required") unless @slug

  fetchCurrentBlock: ->
    @blocks().find(@current_block)

  neighborhoodNames: ->
    _(@neighborhoods).map((neighborhood)-> neighborhood.name)

  outlineMeshes: ->
    App.MeshFactory.loadRegionOutlines(@)

  modelMesh: ->
    App.MeshFactory.loadRegionModel(@)

  blocksMesh: ->
    App.MeshFactory.generateBlocks(@)
