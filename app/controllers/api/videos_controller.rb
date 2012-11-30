class Api::VideosController < ApiController
  def index
    @videos = Video.all
    respond_with @videos
  end

  def show
    respond_with Video.find(params["video_id"])
  end

  def create
    @video = Video.find_or_create_from_panda(params["panda_video_id"])
    respond_with @video, location: api_videos_path
  end

  def callback

  end
end
