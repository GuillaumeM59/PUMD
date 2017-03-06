class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates_presence_of :username, :email, :password, :password_confirmation, on: :create
  validates_presence_of :username, :email, :nom, :prenom, :phone, on: :update
  validates_uniqueness_of :username
 validates :username, length: { in: 4..15 }
 validates :prenom, length: { minimum: 2 }, on: :update
 validates :nom, length: { minimum: 2 }, on: :update
 validates :phone, length: { minimum: 10 }, on: :update
 validates :zipcode, numericality: { only_integer: true },length: { minimum: 5 }, on: :update
validates :password, length: { minimum: 8 }, on: :create
validates :dob, length: {is: 10}
validate :dob_for_majority
attr_accessor :slide, :crop_x, :crop_y, :crop_w, :crop_h
after_update :crop_avatar


ratyrate_rater


scope :is_driver, -> { where(:driver => true) }



def dob_for_majority
  if dob.present? && dob > (Date.today-18.years)
       errors.add(:dob, "Vous devez avoir au moins 18 ans")
     end
end



  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable



#bdd links
  has_many :bids
  has_many :coins
  has_many :trajetpumds


#uploader carrierwave
  mount_uploader :avatar, AvatarUploader

  def crop_avatar
    avatar.recreate_versions! if crop_x.present?
  end

#locate by geocoder
def full_address
[adress, zipcode, city].compact.join(', ')
end

  geocoded_by :full_address
after_validation :geocode

end
