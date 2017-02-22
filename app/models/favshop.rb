class Favshop < ActiveRecord::Base
  belongs_to :user_id
  belongs_to :shop_id
end
