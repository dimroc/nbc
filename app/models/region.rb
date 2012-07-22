class Region < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  has_many :blocks, dependent: :destroy

  after_save :update_bounding_box

  validates_presence_of :name
  validates_presence_of :slug

  class << self
    def from_shapefile(name, shapefile, block_length)
      require 'rgeo/shapefile'

      region = nil
      RGeo::Shapefile::Reader.open(shapefile) do |file|
        raise ArgumentError, "File contains no records" if file.num_records == 0
        region = Region.from_geometry(name, file[0].geometry, block_length)
      end
      region
    end

    def from_geometry(name, geometry, block_length)
      region = Region.new(name: name, geometry: geometry)

      # Generate all blocks that are present in the geometry
      region.bounding_box.step(block_length) do |point, step_x, step_y|
        if region.geometry.contains? point
          region.blocks.build(left: step_x, bottom: step_y, point: point)
        end
      end

      region
    end
  end

  def bounding_box
    @bounding_box ||= update_bounding_box
  end

  private

  def update_bounding_box
    @bounding_box = Cartesian::BoundingBox.create_from_geometry(geometry) if geometry
  end
end
