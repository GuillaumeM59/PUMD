File.open("#{Rails.root}/lib/seeds/Auchan_Drive_Fr2.csv") do |shops|
  shops.read.each_line do |shop|
    longitude, latitude, listname = shop.chomp.split(";")
    #  to remove the quotes from the csv text:
    # code.gsub!(/\A"|"\Z/, '')
    # to create each record in the database
    longitude = longitude.to_f
    latitude = latitude.to_f
    listname2= listname
    name= listname+""
    5.times do
      name[0]=""
    end
    puts longitude , latitude, listname2, name
    Shop.create!(:longitude => longitude, :latitude =>latitude, :brand_id => 4, :name => "Auchan Drive " + name, :listname=>listname2)
    sleep 1
  end
end
