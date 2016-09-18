brandid = Brand.where(name:"Chronodrive").first.id
File.open("#{Rails.root}/lib/seeds/chronodrive.csv") do |shops|
  shops.read.each_line do |shop|
    longitude, latitude, listname = shop.chomp.split(";")
    #  to remove the quotes from the csv text:
    # code.gsub!(/\A"|"\Z/, '')
    # to create each record in the database
    longitude = longitude.to_f
    latitude = latitude.to_f
    name= "Chronodrive "+ listname.to_s
	    zipcode=Geocoder.search("#{latitude},#{longitude}").first.postal_code
    while listname[listname.size-1]==" "
      listname[listname.size-1]=""
    end
    a= zipcode[0]+zipcode[1]+" - "+listname  
    puts longitude , latitude, name, a
    Shop.create!(:longitude => longitude, :latitude =>latitude, :brand_id => brandid, :name => name, :listname=>a)
	sleep 1
  end

end
