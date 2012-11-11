class Region < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  belongs_to :world
  has_many :blocks, dependent: :destroy

  delegate :contains?, to: :geometry

  validates_presence_of :name
  validates_presence_of :slug
  validates_presence_of :left
  validates_presence_of :bottom

  set_rgeo_factory_for_column(:geometry, Mercator::FACTORY.projection_factory)

  def as_json(options={})
    exceptions = [:geometry, :created_at, :updated_at]
    block_exceptions = { blocks: { except: [:point, :created_at, :updated_at] } }
    super({ except: exceptions, include: [block_exceptions] }.merge(options))
  end

  def regenerate_blocks(block_length)
    raise ArgumentError, "block_length is required" unless block_length

    blocks.clear
    bb = generate_bounding_box

    bb.step(block_length) do |point, x, y|
      blocks.build(left: x, bottom: y, point: point) if geometry.contains? point
    end if !bb.empty? && block_length
    blocks
  end

  def regenerate_coordinates
    self.left = furthest_left
    self.bottom = furthest_bottom
  end

  def furthest_left
    self.blocks.min_by(&:left).try(:left) || 0
  end

  def furthest_bottom
    self.blocks.min_by(&:bottom).try(:bottom) || 0
  end

  def generate_bounding_box
    Cartesian::BoundingBox.create_from_geometry(geometry) if geometry
  end
end
