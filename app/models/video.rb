class Video < ActiveRecord::Base
  attr_accessible :duration, :encoding_id, :height, :original_filename,
    :panda_id, :screenshot, :url, :width

  class << self
    def from_panda(panda_id)
      panda = Panda::Encoding.find_by({
        :video_id => panda_id,
        :profile_name => "h264"
      })

      video = Video.new({
        panda_id: panda.video_id,
        encoding_id: panda.id,
        duration: panda.duration,
        height: panda.height,
        width: panda.width,
        original_filename: panda.video.original_filename,
        screenshot: panda.screenshots[0],
        url: panda.url
      })
    end
  end
end
