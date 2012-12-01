class Block::Video < Block
  belongs_to :video

  delegate :encoded?, to: :video, allow_nil: true

  class << self
    def encoded
      joins("INNER JOIN videos ON blocks.video_id = videos.id").
        where("videos.url IS NOT NULL")
    end
  end

  def as_json(options={})
    inclusion = { include: { "video" => { only: [:url, :screenshot, :duration] }}}
    super(options.merge(inclusion))
  end
end
