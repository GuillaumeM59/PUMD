class Brand < ActiveRecord::Base


  has_many :shops


  #uploader carrierwave
    mount_uploader :brandpic, BrandpicUploader

      mount_uploader :minipic, MinibrandUploader


end
