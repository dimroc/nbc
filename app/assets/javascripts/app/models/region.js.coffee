class App.Region extends App.Model
  @configure 'Region', 'id', 'name', 'slug'
  @extend Spine.Model.Ajax

  @hasMany 'blocks', "App.Block"

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
      Spine.Log.log "Error retrieving blocks for region #{@slug}"
      Spine.Log.log "Received status: #{status}. message: #{response.responseText}"
