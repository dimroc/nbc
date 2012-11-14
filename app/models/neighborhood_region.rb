class NeighborhoodRegion < ActiveRecord::Base
  belongs_to :region
  belongs_to :neighborhood
end
