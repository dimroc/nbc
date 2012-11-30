class Block::Video < Block
  belongs_to :video

  def as_json(options={})
    inclusion = { include: { "video" => { only: [:url, :screenshot, :duration] }}}
    super(options.merge(inclusion))
  end
end
