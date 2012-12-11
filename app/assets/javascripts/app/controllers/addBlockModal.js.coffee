class App.Controller.AddBlockModal extends Spine.Controller
  el: "#addBlockModal"

  render: ->
    if _($("#addBlockModal").html()).isBlank()
      $.ajax(method: 'get', url: '/partials/block_video_form').
        success((data) => $('#addBlockModal').html(data))

  activate: ->
    @render()
    $('#addBlockModal').modal()

  deactivate: ->
    $('#addBlockModal').modal()
