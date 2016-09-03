class Coin < ActiveRecord::Base
  has_one :user
  has_one :bid
end
