class App.BuildingMesh
  @show: (neighborhood) ->
    singleton.show(neighborhood)

  _neighborhoodCache: {}
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
      @loadNeighborhood(n)

    dfd = $.Deferred()
    $.when.apply(@, loadingPromises).then(=>
      group = @_updateGroup(neighborhood.slug, neighborhoods)
      dfd.resolve(group))

    dfd

  loadNeighborhood: (neighborhood) ->
    dfd = $.Deferred()

    if !@_neighborhoodCache[neighborhood.slug]
      $.getJSON("/static/neighborhoods/#{neighborhood.slug}.json").
        done((data) => @_updateCache(neighborhood, data, dfd)).
        fail(-> console.log("Failed to retrieve #{neighborhood.slug} buildings", arguments))
    else
      dfd.resolve(@_neighborhoodCache[neighborhood.slug])

    dfd

  _updateCache: (neighborhood, data, dfd) =>
    buildingMeshes = App.MeshFactory.generateFromGeoJson(
      data, {extrude: 0.2, color: 0xFF0000})

    buildingMesh = App.MeshFactory.mergeMeshes(buildingMeshes)
    buildingMesh.isNbcBuilding = true

    @_neighborhoodCache[neighborhood.slug] = buildingMesh

    dfd.resolve(buildingMesh)

  _updateGroup: (slug, neighborhoods) =>
    group = new THREE.Object3D()
    group.isNbcBuilding = true
    for n in neighborhoods
      group.add(@_neighborhoodCache[n.slug])

    @_groups[slug] = group
    group

singleton = new App.BuildingMesh()
