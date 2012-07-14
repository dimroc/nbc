class App.Region extends App.Model
  @configure 'Region', 'id', 'name', 'slug'
  @extend Spine.Model.Ajax

  @hasMany 'blocks', "App.Block"

  @findOrFetch: (slug, callback)->
    region = @findByAttribute("slug", slug)
    if region
      callback(region)
    else
      $.ajax(
        type: "GET",
        url: "/regions",
        dataType: "json",
        cache: false
      ).success((data) =>
        @refresh(data)
        callback(@findByAttribute("slug", slug))
      ).error (response, status) =>
        console.warn "Failed to fetch regions: #{response.responseText}"

  validate: ->
    @errors = {}
    @appendErrors(name: "Name is required") unless @name
    @appendErrors(slug: "slug is required") unless @slug

  fetchBlocks: (successCallback)->
    $.ajax(
      type: "GET",
      url: "/regions/#{@slug}/blocks",
      dataType: "json",
      cache: false
    ).success((data) =>
      @blocks(data)
      successCallback(@) if successCallback
    ).error (response, status)=>
      console.warn "Error retrieving blocks for region #{@slug}"
      console.warn "Received status: #{status}. message: #{response.responseText}"
