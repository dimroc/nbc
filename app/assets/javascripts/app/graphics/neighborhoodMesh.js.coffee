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
      mesh.visible = false
    )

  @resetSelected: ->
    _(App.NeighborhoodMesh.all()).each((mesh) ->
      mesh.material.color.setRGB(0,1,0)
      mesh.visible = true
      mesh.material.wireframe = Env.neighborhoods == "wireframe"
    )

  @_generateMesh: (neighborhood) ->
    rval = App.MeshFactory.generateFromGeoJson(neighborhood.geometry, {ignoreLidFaces: true})

    if Env.neighborhoods == "wireframe"
      _(_(rval).flatten()).each((mesh) ->
        mesh.material.wireframe = true)

    rval

  @_cache: {}
