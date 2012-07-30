class Region < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  belongs_to :world
  has_many :blocks, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :slug

  def as_json(options={})
    super({ except: :geometry, include: [:blocks] }.merge(options))
  end

  def generate_blocks(block_length)
    blocks.clear
    generated_bounding_box.step(block_length) do |point, x, y|
      blocks.build(left: x, bottom: y, point: point) if geometry.contains? point
    end if geometry && block_length
    blocks
  end

  def generated_bounding_box
    Cartesian::BoundingBox.create_from_geometry(geometry) if geometry
  end
end
