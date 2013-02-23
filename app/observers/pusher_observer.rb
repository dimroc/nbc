class PusherObserver < ActiveRecord::Observer
  observe :block

  def after_create(block)
    Pusher.trigger('global', 'newBlock', self.as_json) if pusher_initialized?
  end

  private

  def pusher_initialized?
    Pusher.app_id && Pusher.key && Pusher.secret
  end
end
