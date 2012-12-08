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
    bounding_box = generate_bounding_box
    bounding_box = Hashie::Mash.new bounding_box.as_json
    includes = {
      region_names: region_names,
      mercator_bounding_box: bounding_box.slice(:min_x, :min_y, :max_x, :max_y).as_json
    }

    final_options = { except: [:created_at, :updated_at] }.merge options
    super(final_options).merge(includes)
  end

  def contains?(point)
    regions.any? { |region| region.contains? point }
  end

  def generate_bounding_box
    bb = Cartesian::BoundingBox.new(Cartesian::preferred_factory())
    bounding_boxes = regions.each do |region|
      bb.add(region.generate_bounding_box)
    end
    bb
  end
end
