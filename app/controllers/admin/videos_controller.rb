class Admin::VideosController < ApplicationController
  respond_to :html

  def index
    @access_details = Panda.signed_params('POST', '/videos.json')
    @videos = Panda::Video.all
  end

  def create
    render text: "Created video: #{params.inspect}"
  end
end
