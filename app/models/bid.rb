class Bid < ActiveRecord::Base
  has_many :users
  has_many :coins
  belongs_to :shop
  has_one :brand
  has_many :feedbacks

validates_presence_of :shop_id, :driver_id, :go_at



end
