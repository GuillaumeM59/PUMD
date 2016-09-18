class Car < ActiveRecord::Base
  belongs_to :user_id


    #uploader carrierwave
      mount_uploader :carpic, CarpicUploader

end
