class Api::VideoController < ApiController
  def index
    @videos = Panda::Video.all
    respond_with @videos
  end
end
