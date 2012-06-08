class Region < ActiveRecord::Base
  has_many :blocks

  validates_presence_of :name
end
