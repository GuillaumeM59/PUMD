class Trajetpumd < ActiveRecord::Base
  belongs_to :user, foreign_key: :driver_id
  belongs_to :shop, foreign_key: :shop_id
  has_one :resapumd, foreign_key: :trajet_id
  has_many :transactions, foreign_key: :trajetpumd_id
  has_one :resapumd, foreign_key: :trajet_id
  validates_presence_of :maxsac, :do_at
  def self.isactive
    start_date = DateTime.now+1.hour
    end_date = DateTime.now+1.week
    where(:do_at => start_date..end_date)
  end
  # scope :trajetsactifs, -> { where(:do_at => start_date..end_date) }
  attr_accessor :brand_id, :custom_address, :username, :do_around

  ratyrate_rateable "Quality"

  reverse_geocoded_by :driver_lat, :driver_lon
  after_validation :geocode          # auto-fetch coordinates
end
