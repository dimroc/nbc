class BlocksController < ApiController
  before_filter :fetch_current_point
  load_resource :world

  def index
    if @current_point
      current_block = Block.near(@current_point).limit(1).first
      raise NotFoundError unless @world.contains? @current_point
      respond_with [current_block]
    else
      respond_with Block.all
    end
  end
end
