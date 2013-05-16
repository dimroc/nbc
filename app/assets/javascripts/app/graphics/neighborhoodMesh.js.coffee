class App.NeighborhoodMesh
  @all: ->
    meshes = for neighborhood in App.Neighborhood.all()
      App.NeighborhoodMesh.find(neighborhood.id)

    meshes = _(meshes).flatten()

  @find: (neighborhoodId) ->
    if !@_cache[neighborhoodId]
      @_cache[neighborhoodId] = @_generateMesh(App.Neighborhood.find(neighborhoodId))
    @_cache[neighborhoodId]

  @select: (neighborhoodId) ->
    App.NeighborhoodMesh.resetSelected()

    meshes = _(App.NeighborhoodMesh.find(neighborhoodId)).flatten()
    _(meshes).each((mesh) ->
      mesh.material.color.setRGB(1,0,0)
    )

  @resetSelected: ->
    _(App.NeighborhoodMesh.all()).each((mesh) ->
      mesh.material.color.setRGB(0,1,0)
    )

  @_generateMesh: (neighborhood) ->
    App.MeshFactory.generateFromGeoJson(neighborhood.geometry)

  @_cache: {}
