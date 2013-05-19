class App.BuildingMesh
  @show: (neighborhood) ->
    singleton.show(neighborhood)

  _cache: {}

  show: (neighborhood) ->
    if @_cache[neighborhood.slug]
      @render(@_cache[neighborhood.slug])
    else
      @load(neighborhood).done(@render)

  render: (buildingGroup) =>
    console.log "Rendering buildings..."
    App.WorldRenderer.instance().setBuildings([buildingGroup])

  load: (neighborhood) ->
    dfd = $.Deferred()
    $.getJSON("/static/neighborhoods/#{neighborhood.slug}.json").
      done((data) => @_updateCache(neighborhood, data, dfd)).
      fail(-> console.log("Failed to retrieve #{neighborhood.slug} buildings", arguments))

    dfd

  _updateCache: (neighborhood, data, dfd) =>
    buildingMeshes = App.MeshFactory.generateFromGeoJson(
      data, {extrude: 0.2, color: 0xFF0000})

    buildingMesh = App.MeshFactory.mergeMeshes(buildingMeshes)

    group = new THREE.Object3D()
    group.add(buildingMesh)
    group.isNbcBuilding = true

    @_cache[neighborhood.slug] = group
    dfd.resolve(group)

singleton = new App.BuildingMesh()
