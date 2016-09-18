require 'csv'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

k=0
carbrandlist =[]
File.open("#{Rails.root}/lib/seeds/car.csv") do |lignes|
  lignes.read.each_line do |car|
    car.gsub!(/\A"|"\Z/, '')
    year, brand, model = car.chomp.split(";")
    #  to remove the quotes from the csv text:
    # to create each record in the database
carbrandlist << brand.to_s
end
end

carbrandlist = carbrandlist.uniq
carbrandlist.size.times do |i|
  Carbrand.create!(name:carbrandlist[i])
end



File.open("#{Rails.root}/lib/seeds/car.csv") do |lignes|
  lignes.read.each_line do |car|
    car.gsub!(/\A"|"\Z/, '')
    year, brand, model = car.chomp.split(";")
    #  to remove the quotes from the csv text:
    # to create each record in the database
        carbrandid= Carbrand.where(name:brand.to_s).first.id
        Carmodel.create!(carbrand_id: carbrandid, name: model.to_s, year: year)

  end
  end







villes = ["Armentière", "Quesnoy sur deule", "Roubaix", "Linselles", "Tourcoing","Lomme", "Lambersart", "Pérenchies", "Saint André lez Lille", "Leers", "Wattrelos", "Lille", "Croix", "Mouvaux", "Halluin", "Roncq", "Wasquehal", "Lys les Lannoy", "Marcq-en-Baroeul",
   "Bondues", "Villeneuve d'ascq"]
categories = ["hypermarché", "supermarché", "proximité", "Drive", "bricolage", "ameublement", "jardinage"]
User.delete_all

    adimage_src= File.join("#{Rails.root}/public/img/default_pict/admin.jpeg")
    adsrc_file= File.new(adimage_src)
    User.create!(
        username: 'guidev',
        email: 'dev.guillaumem59@gmail.com',
        password:"12345678",
        adress:'9 rue de lorraine ',
        zipcode: '59100',
        dob:Date.today,
        password_confirmation:"12345678",
        prenom: 'Guillaume',
        nom: 'Manier',
        comment: 'Administrator, developper',
        city: 'Roubaix',
        avatar: adsrc_file,
        admin:true,
        subscribe:true
        )

Brand.delete_all
usimage_src= File.join("#{Rails.root}/public/img/Logos-Enseignes/Alimentaire/Carrefour.png")
ussrc_file= File.new(usimage_src)
Brand.create!(
      name:"Carrefour",
      category:categories[0],
      brandpic:ussrc_file
)
usimage_src= File.join("#{Rails.root}/public/img/Logos-Enseignes/Alimentaire/Auchan.png")
ussrc_file= File.new(usimage_src)
Brand.create!(
      name:"Auchan",
      category:categories[0],
            brandpic:ussrc_file
)
usimage_src= File.join("#{Rails.root}/public/img/Logos-Enseignes/Alimentaire/Leclercq.png")
ussrc_file= File.new(usimage_src)
Brand.create!(
      name:"Eleclerc",
      category:categories[0],
            brandpic:ussrc_file
)




# Get Brand ID
carrefour_id= Brand.where(name:"Carrefour").first.id
auchan_id= Brand.where(name:"Auchan").first.id
lecler_id= Brand.where(name:"Eleclerc").first.id



Shop.delete_all


# Create Carrefour shops
File.open("#{Rails.root}/lib/seeds/Carrefourhdf.csv") do |shops|
  shops.read.each_line do |shop|
    name, city, zipcode, latitude, longitude = shop.chomp.split(";")
    #  to remove the quotes from the csv text:
    #code.gsub!(/\A"|"\Z/, '')
    # to create each record in the database
    Shop.create!(:zipcode => zipcode.to_s, :longitude => longitude, :latitude =>latitude, :brand_id => carrefour_id, :name => "Carrefour " + name)
    sleep 1
  end
end

# Create Auchan shops
File.open("#{Rails.root}/lib/seeds/AuchanMEL.csv") do |shops|
  shops.read.each_line do |shop|
    long, lat, nom, cc, route = shop.chomp.split(";")
    #  to remove the quotes from the csv text:
    #code.gsub!(/\A"|"\Z/, '')
    # to create each record in the database
    Shop.create!(:longitude => long, :latitude =>lat, :brand_id => auchan_id, :name => nom)
    sleep 1
  end
end
File.open("#{Rails.root}/lib/seeds/ELeclercMEL.csv") do |shops|
  shops.read.each_line do |shop|
    long, lat, nom = shop.chomp.split(",")
    #  to remove the quotes from the csv text:
    #code.gsub!(/\A"|"\Z/, '')
    # to create each record in the database
    Shop.create!(:longitude => long, :latitude =>lat, :brand_id => lecler_id, :name => nom)
    sleep 1
  end
end
