class BlocksController < ApiController
  before_filter :fetch_current_point
  load_resource :world

  def index
    if @current_point
      current_block = @world.blocks.near(@current_point).limit(1).first
      raise NotFoundError unless current_block.region.contains? @current_point
      respond_with [current_block]
    else
      respond_with @world.blocks
    end
  end
end
