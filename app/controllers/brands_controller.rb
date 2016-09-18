class BrandsController < ApplicationController
  before_action :set_brand, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:index, :show, :new, :create, :destroy]
  before_filter :is_admin, only: [:index, :show, :create, :new, :destroy]

  # GET /brands
  # GET /brands.json
  def index
    if current_user.admin
    @brands = Brand.all
    else
      respond_to do |format|
          format.html { redirect_to root_path, notice: "Votre n'avez pas les droits d'acces"  }
          format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /brands/1
  # GET /brands/1.json
  def show
    @shopslist = Shop.where(brand_id:@brand)
    @hash = Gmaps4rails.build_markers(@shopslist) do |shopitem, marker|
      marker.lat shopitem.latitude
      marker.lng shopitem.longitude

    end
  end

  # GET /brands/new
  def new
    @brand = Brand.new
  end

  # GET /brands/1/edit
  def edit
  end

  # POST /brands
  # POST /brands.json
  def create
    @brand = Brand.new(brand_params)

    respond_to do |format|
      if @brand.save
        format.html { redirect_to @brand, notice: 'Brand was successfully created.' }
        format.json { render :show, status: :created, location: @brand }
      else
        format.html { render :new }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /brands/1
  # PATCH/PUT /brands/1.json
  def update
    respond_to do |format|
      if @brand.update(brand_params)
        format.html { redirect_to @brand, notice: 'Brand was successfully updated.' }
        format.json { render :show, status: :ok, location: @brand }
      else
        format.html { render :edit }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brands/1
  # DELETE /brands/1.json
  def destroy
    @brand.destroy
    respond_to do |format|
      format.html { redirect_to brands_url, notice: 'Brand was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brand
      @brand = Brand.find(params[:id])
    end
  def is_admin
    if current_user.admin
      true
    else
      respond_to do |format|
          format.html { redirect_to root_path, notice: "Votre n'avez pas les droits d'acces"  }
          format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
  end
end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brand_params
      params.require(:brand).permit(:name, :category, :brandpic, :minipic)
    end
end
