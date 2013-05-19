class App.BuildingMeshRepo
  _cache: {}

  load: (neighborhood) ->
    dfd = $.Deferred()

    if !@_cache[neighborhood.slug]
      $.getJSON("#{Constants.staticBasePath}/neighborhoods/#{neighborhood.slug}.json").
        done((data) => @_updateCache(neighborhood, data, dfd)).
        fail(-> console.log("Failed to retrieve #{neighborhood.slug} buildings", arguments))
    else
      dfd.resolve(@_cache[neighborhood.slug])

    dfd

  find: (slug) ->
    @_cache[slug]

  _updateCache: (neighborhood, data, dfd) ->
    buildingMeshes = App.MeshFactory.generateFromGeoJson(
      data, {extrude: 0.2, color: 0xFF0000})

    buildingMesh = App.MeshFactory.mergeMeshes(buildingMeshes)
    buildingMesh.isNbcBuilding = true

    @_cache[neighborhood.slug] = buildingMesh
    dfd.resolve(buildingMesh)

