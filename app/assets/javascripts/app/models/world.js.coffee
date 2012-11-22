class App.World extends App.Model
  @configure 'World', 'id', 'name', 'slug'
  @extend Spine.Model.Ajax

  @hasMany 'regions', "App.Region"

  @findOrFetch: (slug, callback)->
    world = @findByAttribute("slug", slug)
    if world
      callback(world)
    else
      $.ajax(
        type: "GET",
        url: "/worlds",
        dataType: "json",
        cache: false
      ).success((data) =>
        @refresh(data)
        callback(@findByAttribute("slug", slug))
      ).error (response, status) =>
        console.warn "Failed to fetch worlds: #{response.responseText}"

  validate: ->
    @errors = {}
    @appendErrors(name: "Name is required") unless @name
    @appendErrors(slug: "slug is required") unless @slug

  allBlocks: ->
    _.reduce(@regions().all(), (memo, region) ->
      memo.concat(region.blocks().all())
    , [])

  currentRegion: ->
    _.detect(@regions().all(), (entry)-> entry.current_block )

  currentNeighborhoods: ->
    currentRegion = @currentRegion()
    currentRegion.neighborhoodNames() if currentRegion

  selectedRegions: ->
    _([@currentRegion()]).compact()

  fetchRegions: (successCallback)->
    url = "/worlds/#{@slug}/regions"
    url += "?longitude=#{Env.longitude}&latitude=#{Env.latitude}" if Env.geoposition
    $.ajax(
      type: "GET",
      url: url,
      dataType: "json",
      cache: false
    ).success((data) =>
      @regions(data)
      successCallback(@) if successCallback
    ).error (response, status)=>
      console.warn "Error retrieving regions for world #{@slug}"
      console.warn "Received status: #{status}. message: #{response.responseText}"

  outline_meshes: ->
    _regions = _(@selectedRegions())
    _regions.chain()
      .map((region) -> region.outline_meshes())
      .flatten()
      .compact()
      .value()

  model_meshes: ->
    _.chain(@regions().all())
      .map((region) -> region.model_mesh())
      .compact()
      .value()

  selected_block_meshes: ->
    _.chain(@selectedRegions()).
      map((region) -> App.MeshFactory.generate_block(region.fetchCurrentBlock())).
      compact().
      value()

  all_blocks_meshes: ->
    _regions = _(@selectedRegions())
    _regions.map((region) -> region.blocks_mesh())
