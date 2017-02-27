class FavshopsController < ApplicationController
  before_action :set_favshop, only: [:show, :edit, :update, :destroy]

  # GET /favshops
  # GET /favshops.json
  def index
    @favshops = Favshop.all
  end

  # GET /favshops/1
  # GET /favshops/1.json
  def show
  end

  # GET /favshops/new
  def new
    @favshop = Favshop.new
  end

  # GET /favshops/1/edit
  def edit
  end

  # POST /favshops
  # POST /favshops.json
  def create
    @favshop = Favshop.new(favshop_params)

    respond_to do |format|
      if @favshop.save
        format.html { redirect_to @favshop, notice: 'Favshop was successfully created.' }
        format.json { render :show, status: :created, location: @favshop }
      else
        format.html { render :new }
        format.json { render json: @favshop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /favshops/1
  # PATCH/PUT /favshops/1.json
  def update
    respond_to do |format|
      if @favshop.update(favshop_params)
        format.html { redirect_to @favshop, notice: 'Favshop was successfully updated.' }
        format.json { render :show, status: :ok, location: @favshop }
      else
        format.html { render :edit }
        format.json { render json: @favshop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /favshops/1
  # DELETE /favshops/1.json
  def destroy
    @favshop.destroy
    respond_to do |format|
      format.html { redirect_to favshops_url, notice: 'Favshop was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favshop
      @favshop = Favshop.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def favshop_params
      params.require(:favshop).permit(:user_id_id, :shop_id_id)
    end
end
