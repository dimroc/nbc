class App.BuildingGroupRepo
  constructor: ->
    @_cache = {}
    @_geometryRepo = new App.BuildingGeometryRepo()

  load: (neighborhood) ->
    neighborhoods = neighborhood.neighbors()
    neighborhoods.unshift(neighborhood)

    loadingPromises = for n in neighborhoods
      @_geometryRepo.load(n)

    dfd = $.Deferred()
    $.when.apply(@, loadingPromises).then(=>
      group = @_updateGroup(neighborhood.slug, neighborhoods)
      dfd.resolve(group))

    dfd

  _updateGroup: (slug, neighborhoods) =>
    group = new THREE.Object3D()
    group.name = "buildingGroup: #{slug}"
    group.isNbcBuilding = true
    for n in neighborhoods
      selected = slug == n.slug
      group.add(@_geometryRepo.createMesh(n.slug, selected))

    @_cache[slug] = group
    group
