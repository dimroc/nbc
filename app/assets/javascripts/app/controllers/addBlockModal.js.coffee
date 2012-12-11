class App.Controller.AddBlockModal extends Spine.Controller
  constructor: (domElement) ->
    super
    $(domElement).prepend @view("addBlockModal")

  render: ->
    if _($("#addBlockModal form").html()).isBlank()
      $.ajax(method: 'get', url: '/partials/block_video_form').
        success((data) => $('#addBlockModal').html(data))

  activate: ->
    @render()
    $('#addBlockModal').modal()

  deactivate: ->
    $('#addBlockModal').modal()
