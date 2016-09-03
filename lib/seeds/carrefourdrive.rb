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
    puts longitude , latitude, listname, name
    Shop.create!(:longitude => longitude, :latitude =>latitude, :brand_id => brandid, :name => name, :listname=>listname)
    sleep 1
    zipcode=Geocoder.search("#{latitude},#{longitude}").first.postal_code
    puts zipcode
    currentshop=Shop.all.last
    listname= currentshop.listname
    n=0
    if listname != nil
    if n==0
      i=listname.size
      if listname[i-1]==" "
        listname[i-1]=""
      else
        n+=1
      end
    else
    end
    end
    currentshop.update_attributes(:listname=> zipcode[0]+zipcode[1]+" - "+listname)
    sleep 1
  end

end
