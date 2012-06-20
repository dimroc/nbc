class Region < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :blocks

  validates_presence_of :name
  validates_presence_of :slug
end
