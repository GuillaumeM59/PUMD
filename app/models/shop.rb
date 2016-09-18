class Shop < ActiveRecord::Base
default_scope { order('listname ASC')}
  belongs_to :brand
  has_many :bids
  has_many :trajetpumds
  has_one :city

def full_street_address

end




  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode          # auto-fetch coordinates


end
