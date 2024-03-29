class AvatarUploader < CarrierWave::Uploader::Base
 include CarrierWave::MiniMagick
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick


  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  def default_url(*args)
   ActionController::Base.helpers.asset_path([version_name, "default.png"].compact.join('_'))
end

 version :large do
  process resize_to_fit: [600,600]
end
 version :medium do
  process resize_to_fit: [350,350]
end
 version :small do
  process resize_to_fit: [200,200]
end
 version :thumb do
   process resize_to_fit: [600,600]
  process :crop
  process resize_to_fit: [150,150]
end
 version :marker do
   process resize_to_fit: [600,600]
   process :crop
  process resize_to_fit: [32,32]
end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{Rails.root}/public/img/avataruser"
  end


def crop
  if model.crop_x.present?
    manipulate! do |img|
      x = model.crop_x.to_i
      y = model.crop_y.to_i
      w = model.crop_w.to_i
      h = model.crop_h.to_i
      img.crop "#{w}x#{h}+#{x}+#{y}"
    end
  end
end
  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
