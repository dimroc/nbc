class Neighborhood < ActiveRecord::Base
  validates_presence_of :name, :borough, :point
end
