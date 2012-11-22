class App.Region extends App.Model
  @configure 'Region', 'id', 'name', 'slug', 'left', 'bottom', 'current_block'
  @extend Spine.Model.Ajax

  @hasMany 'blocks', "App.Block"

  validate: ->
    @errors = {}
    @appendErrors(name: "Name is required") unless @name
    @appendErrors(slug: "slug is required") unless @slug
    @appendErrors(left: "left is required") unless @left
    @appendErrors(bottom: "bottom is required") unless @bottom

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
