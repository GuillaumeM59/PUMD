brandid = Brand.where(name:"Carrefour Drive").first.id
File.open("#{Rails.root}/lib/seeds/carrefour_drive_Fr.csv") do |shops|
  shops.read.each_line do |shop|
    longitude, latitude, listname = shop.chomp.split(";")
    #  to remove the quotes from the csv text:
    # code.gsub!(/\A"|"\Z/, '')
    # to create each record in the database
    longitude = longitude.to_f
    latitude = latitude.to_f
    name= "Carrefour Drive "+listname
     puts listname
    sleep 1
    zipcode=Geocoder.search("#{latitude},#{longitude}").first.postal_code
    puts zipcode

    if listname != nil
    while listname[listname.size-1]==" "
    listname[listname.size-1]=""
    end
puts listname
    end
    a=zipcode[0]+zipcode[1]+" - "+listname
puts a

	puts longitude , latitude, name, a
    Shop.create!(:longitude => longitude, :latitude =>latitude, :brand_id => brandid, :name => name, :listname=>a)
end
end
