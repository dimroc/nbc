class World < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  has_many :regions, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :slug

  def as_json(options={})
    # Opted for manual merge rather than
    # passing regions: { only: :name } for performance with region queries.
    region_names = regions.map(&:slug)
    includes = {
      region_names: region_names,
      mercator_bounding_box: bounding_box_as_json(generate_bounding_box),
      mesh_bounding_box: bounding_box_as_json(generate_mesh_bounding_box),
    }

    final_options = { except: [:created_at, :updated_at] }.merge options
    super(final_options).merge(includes)
  end

  def contains?(point)
    regions.any? { |region| region.contains? point }
  end

  #TODO: Persist for optimization
  def generate_bounding_box
    bb = Cartesian::BoundingBox.new(Cartesian::preferred_factory())
    bounding_boxes = regions.each do |region|
      bb.add(region.generate_bounding_box)
    end
    bb
  end

  #TODO: Persist for optimization
  def generate_mesh_bounding_box
    bb = Cartesian::BoundingBox.new(Cartesian::preferred_factory())
    outlines = regions.map(&:threejs).map { |threejs| threejs[:outlines] }.flatten

    outlines.each_slice(2) do |slice|
      point = Cartesian::preferred_factory().point(slice[0], slice[1])
      bb.add point
    end

    bb
  end

  private

  def bounding_box_as_json(bb)
    mash = Hashie::Mash.new bb.as_json
    mash.slice(:min_x, :min_y, :max_x, :max_y).as_json
  end
end
