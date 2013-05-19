class App.BuildingMesh
  @show: (neighborhood) ->
    singleton.show(neighborhood)

  constructor: ->
    @_repo = new App.BuildingMeshRepo()

  _groups: {}

  show: (neighborhood) ->
    repository = @_groups
    #repository = @_neighborhoodCache

    if repository[neighborhood.slug]
      @render(repository[neighborhood.slug])
    else
      @load(neighborhood).done(@render)

  render: (mesh) =>
    console.log "Rendering buildings..."
    App.WorldRenderer.instance().setBuildings([mesh])

  load: (neighborhood) ->
    neighborhoods = neighborhood.neighbors()
    neighborhoods.unshift(neighborhood)

    loadingPromises = for n in neighborhoods
      @_repo.load(n)

    dfd = $.Deferred()
    $.when.apply(@, loadingPromises).then(=>
      group = @_updateGroup(neighborhood.slug, neighborhoods)
      dfd.resolve(group))

    dfd

  _updateGroup: (slug, neighborhoods) =>
    group = new THREE.Object3D()
    group.isNbcBuilding = true
    for n in neighborhoods
      group.add(@_repo.find(n.slug))

    @_groups[slug] = group
    group

singleton = new App.BuildingMesh()
