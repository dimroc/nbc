class App.BuildingGeometryRepo
  constructor: ->
    @_cache = {}

  load: (neighborhood) ->
    dfd = $.Deferred()

    if !@_cache[neighborhood.slug]
      $.getJSON("#{Constants.staticBasePath}/neighborhoods/#{neighborhood.slug}.json").
        done((data) => @_updateCache(neighborhood, data, dfd)).
        fail(-> console.log("Failed to retrieve #{neighborhood.slug} buildings", arguments))
    else
      dfd.resolve(@_cache[neighborhood.slug])

    dfd

  createMesh: (slug) ->
    raise "#{slug} not in repository. load() first?" if !@_cache[slug]
    geometry = @_cache[slug]
    buildingMesh = new THREE.Mesh(geometry, new THREE.MeshLambertMaterial({color: 0xFF0000}))

    buildingMesh.name = "buildings: #{slug}"
    buildingMesh.isNbcBuilding = true
    buildingMesh

  _updateCache: (neighborhood, data, dfd) ->
    geometry = @_fetchGeometry(neighborhood, data)
    dfd.resolve(geometry)

  _fetchGeometry: (neighborhood, data) ->
    if !@_cache[neighborhood.slug]
      geometries = App.MeshFactory.generateFromGeoJson(data, {extrude: 0.2})
      @_cache[neighborhood.slug] = App.MeshFactory.mergeMeshes(geometries)

    @_cache[neighborhood.slug]
