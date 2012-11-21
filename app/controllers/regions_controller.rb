class RegionsController < ApiController
  before_filter :fetch_current_point
  load_resource :world

  def index
    as_json = @world.regions.as_json
    set_current_block(as_json)

    respond_with(as_json)
  end

  private

  def set_current_block(as_json)
    return unless @current_point

    if @world.contains?(@current_point)
      current_block = @world.blocks.near(@current_point).limit(1).first

      current_region = as_json.detect { |entry| entry["id"] == current_block.region_id }
      current_region.merge!("current_block" => current_block.id)
    end
  end
end
