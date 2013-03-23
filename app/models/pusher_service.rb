class PusherService
  class << self
    def push_block(block)
      log_failure do
        Pusher.trigger('global', 'block', block.as_json)
      end
    end

    def initialized?
      Pusher.app_id && Pusher.key && Pusher.secret
    end

    private

    def log_failure
      if initialized?
        yield
      else
        Rails.logger.warn "Pusher is uninitialized!"
      end
    rescue Pusher::Error => e
      Rails.logger.warn "Unable to push block to clients\n#{e.message}"
    end
  end
end
