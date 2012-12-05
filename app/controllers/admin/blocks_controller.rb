class Admin::BlocksController < AdminController
  respond_to :html

  def index
    @blocks = Block.all
  end
end
