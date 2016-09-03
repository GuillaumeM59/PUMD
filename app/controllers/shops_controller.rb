class ShopsController < ApplicationController
  before_action :set_shop, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:index, :show, :new, :create, :destroy]
  before_filter :is_admin, only: [:index, :show, :destroy]

  # GET /shops
  # GET /shops.json
  def index
    @shops = Shop.all
    @hash = Gmaps4rails.build_markers(@shops) do |shop, marker|
  marker.lat shop.latitude
  marker.lng shop.longitude
    end
    if current_user
      @aroundshop = Shop.near([current_user.latitude, current_user.longitude], 20, :units => :km)
    end
  end

  # GET /shops/1
  # GET /shops/1.json
  def show

    require 'open-uri'
    file_path="http://www.auchan.fr/magasins/st-quentin/sl-103"
    doc = Nokogiri::HTML(open(file_path))
    @actus= doc.at_css(".bloc-actus")
    @hours= doc.at_css(".store-schedule")
@actus.css("img").each do |image|
 if image["src"][0] == "/"
   image["src"] = "http://www.auchan.fr" + image["src"]

 end
end

    @actualites= @actus.to_html.html_safe
    @horaires=@hours.to_html.html_safe

    @hash = Gmaps4rails.build_markers(@shop) do |shop, marker|
      marker.lat shop.latitude
      marker.lng shop.longitude
    end
  end

  # GET /shops/new
  def new
    @shop = Shop.new
  end

  # GET /shops/1/edit
  def edit
  end

  # POST /shops
  # POST /shops.json
  def create
    @shop = Shop.new(shop_params)

    respond_to do |format|
      if @shop.save
        format.html { redirect_to @shop, notice: 'Shop was successfully created.' }
        format.json { render :show, status: :created, location: @shop }
      else
        format.html { render :new }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shops/1
  # PATCH/PUT /shops/1.json
  def update
    respond_to do |format|
      if @shop.update(shop_params)
        format.html { redirect_to @shop, notice: 'Shop was successfully updated.' }
        format.json { render :show, status: :ok, location: @shop }
      else
        format.html { render :edit }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shops/1
  # DELETE /shops/1.json
  def destroy
    @shop.destroy
    respond_to do |format|
      format.html { redirect_to shops_url, notice: 'Shop was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find(params[:id])
    end

    def is_admin
      if current_user.admin
        true
      else
        respond_to do |format|
            format.html { redirect_to root_path, notice: "Votre n'avez pas les droits d'acces"  }
            format.json { render json: @shop.errors, status: :unprocessable_entity }
        end
    end
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def shop_params
      params.require(:shop).permit(:brand_id, :name, :address, :zipcode, :city, :isdrive, :longitude, :latitude, :listname)
    end
end
