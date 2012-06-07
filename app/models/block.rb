class Block
  include Mongoid::Document
  include Mongoid::Timestamps

  validates_presence_of :left
  validates_presence_of :top

  field :left, type: Integer
  field :top, type: Integer

  embedded_in :region
end
