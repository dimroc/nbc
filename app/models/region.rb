class Region
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  embeds_many :blocks, cascade_callbacks: true

  validates_presence_of :name
end
