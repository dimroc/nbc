class Block < ActiveRecord::Base
  belongs_to :region

  validates_presence_of :left
  validates_presence_of :bottom
end
