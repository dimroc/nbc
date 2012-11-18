class World < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  has_many :regions, dependent: :destroy
  has_many :blocks, through: :regions

  validates_presence_of :name
  validates_presence_of :slug

  def generate_bounding_box
    bb = Cartesian::BoundingBox.new(Cartesian::preferred_factory())
    bounding_boxes = regions.each do |region|
      bb.add(region.generate_bounding_box)
    end
    bb
  end
end
