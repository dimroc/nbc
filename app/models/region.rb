class Region < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  belongs_to :world
  has_many :blocks, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :slug
  validates_presence_of :left
  validates_presence_of :bottom

  set_rgeo_factory_for_column(:geometry, Mercator::FACTORY.projection_factory)

  def as_json(options={})
    exceptions = [:geometry, :created_at, :updated_at]
    super({ except: exceptions, include: [:blocks] }.merge(options))
  end

  def generate_blocks(block_length)
    raise ArgumentError, "block_length is required" unless block_length

    blocks.clear
    bb = generated_bounding_box

    bb.step(block_length) do |point, x, y|
      point = Mercator::FACTORY.point(point.x, point.y)
      blocks.build(left: x, bottom: y, point: point) if geometry.contains? point
    end if !bb.empty? && block_length
    blocks
  end

  def generated_bounding_box
    Cartesian::BoundingBox.create_from_geometry(geometry) if geometry
  end
end
