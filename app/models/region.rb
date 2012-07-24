class Region < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  belongs_to :world
  has_many :blocks, dependent: :destroy

  after_save :update_bounding_box

  validates_presence_of :name
  validates_presence_of :slug

  def bounding_box
    @bounding_box ||= update_bounding_box
  end

  private

  def update_bounding_box
    @bounding_box = Cartesian::BoundingBox.create_from_geometry(geometry) if geometry
  end
end
