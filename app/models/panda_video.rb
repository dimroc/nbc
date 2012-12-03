class PandaVideo < ActiveRecord::Base
  attr_accessible :duration, :encoding_id, :height, :original_filename,
    :panda_id, :screenshot, :url, :width

  validates_uniqueness_of :panda_id

  has_one :block_video, dependent: :destroy, class_name: ::Block::Video

  scope :encoded, -> { where("panda_videos.url IS NOT NULL") }

  class << self
    def find_or_create_from_panda(panda_id)
      panda = Panda::Encoding.find_by({
        :video_id => panda_id,
        :profile_name => "h264"
      })

      video = PandaVideo.create({
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

  def refresh_from_panda!
    panda = Panda::Encoding.find_by({
      :video_id => panda_id,
      :profile_name => "h264"
    })

    update_attributes(url: panda.url, screenshot: panda.screenshots[0]) if panda
  end

  def exists_in_panda?
    Panda::Video.find(panda_id)
  rescue Panda::APIError
    false
  end

  def encoded?
    self.url.present?
  end
end
