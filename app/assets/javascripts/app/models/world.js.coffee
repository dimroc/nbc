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

  fetchRegions: (successCallback)->
    $.ajax(
      type: "GET",
      url: "/worlds/#{@slug}/regions",
      dataType: "json",
      cache: false
    ).success((data) =>
      @blocks(data)
      successCallback(@) if successCallback
    ).error (response, status)=>
      console.warn "Error retrieving regions for world #{@slug}"
      console.warn "Received status: #{status}. message: #{response.responseText}"
