class Api::BlocksController < ApiController
  before_filter :fetch_current_point
  load_resource :world

  def index
    if @current_point
      respond_with Block.near(@current_point).limit(20)
    else
      respond_with Block.all
    end
  end

  def create
    raise ActiveResource::BadRequest, "No location given" unless @current_point
    if params[:video_id]
      block = Block::Video.create(point: @current_point, video: PandaVideo.find(params[:video_id]))
    end

    respond_with block, location: api_block_path(block)
  end
end
