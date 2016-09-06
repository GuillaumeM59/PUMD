class Trajetpumd < ActiveRecord::Base
  belongs_to :user, foreign_key: :driver_id
  belongs_to :shop, foreign_key: :shop_id
  has_one :resapumd, foreign_key: :trajet_id
  has_many :transactions, foreign_key: :trajetpumd_id
  has_one :resapumd, foreign_key: :trajet_id
  validates_presence_of :maxsac, :do_at
  start_date = DateTime.now+2.hours
  end_date = DateTime.now+1.week
  scope :trajetsactifs, -> { where(:do_at => start_date..end_date) }
  attr_accessor :brand_id, :custom_address

  reverse_geocoded_by :driver_lat, :driver_lon
  after_validation :geocode          # auto-fetch coordinates
end
