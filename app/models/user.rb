class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates_presence_of :city, :username, :nom, :prenom, :email, :adress, :zipcode, :dob, :password, :password_confirmation, on: :create
  validates_presence_of :city, :username, :nom, :prenom, :email, :adress, :zipcode, :dob, on: :update
  validates_uniqueness_of :username, :email
  validates_presence_of :cbrand_id,:if => :driver?
  validates_presence_of :cmodel_id,:if => :driver?
  validates_presence_of :carsize, :if => :driver?
validates :gender,:presence => { :if => 'gender.nil?' }, inclusion: { in: [true, false] }
 validates :username, length: { in: 4..15 }
 validates :prenom, length: { minimum: 2 }
 validates :nom, length: { minimum: 2 }
 validates :phone, length: { minimum: 10 }
 validates :zipcode, numericality: { only_integer: true },length: { minimum: 5 }
validates :password, length: { minimum: 8 }, on: :create
validates :dob, length: {is: 10}
validate :dob_for_majority
validates_confirmation_of :password, on: :create,
                              message: 'ne correspondent pas'

   after_create :build_profile



scope :is_driver, -> { where(:driver => true) }



def dob_for_majority
  if dob.present? && dob > (Date.today-18.years)
       errors.add(:dob, "Vous devez avoir au moins 18 ans")
     end
end


    def build_profile
      @coin1 = Coin.new
      @coin1.user_id = self.id
      @coin1.comment1 = "Welcome cocoin 1"
      @coin1.save
      @coin2 = Coin.new
      @coin2.user_id = self.id
      @coin2.comment1 = "Welcome cocoin 2"
      @coin2.save
      @transaction = Transaction.new
      @transaction.user_id = self.id
      @transaction.comment = "Welcome 3€"
      @transaction.tvalue = 3.0
      @transaction.save
    end


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

#bdd links
  has_many :bids
  has_many :coins
  has_many :trajetpumds


#uploader carrierwave
  mount_uploader :avatar, AvatarUploader


#locate by geocoder
def full_address
[adress, zipcode, city].compact.join(', ')
end

  geocoded_by :full_address
after_validation :geocode

end
