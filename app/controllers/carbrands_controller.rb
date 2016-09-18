class CarbrandsController < ApplicationController
  before_action :set_carbrand, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:index, :show, :new, :create, :destroy]
  before_filter :is_admin, only: [:index, :show, :create, :new, :destroy]

  # GET /carbrands
  # GET /carbrands.json
  def index
    @carbrands = Carbrand.all
  end

  # GET /carbrands/1
  # GET /carbrands/1.json
  def show
  end

  # GET /carbrands/new
  def new
    @carbrand = Carbrand.new
  end

  # GET /carbrands/1/edit
  def edit
  end

  # POST /carbrands
  # POST /carbrands.json
  def create
    @carbrand = Carbrand.new(carbrand_params)

    respond_to do |format|
      if @carbrand.save
        format.html { redirect_to @carbrand, notice: 'Carbrand was successfully created.' }
        format.json { render :show, status: :created, location: @carbrand }
      else
        format.html { render :new }
        format.json { render json: @carbrand.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carbrands/1
  # PATCH/PUT /carbrands/1.json
  def update
    respond_to do |format|
      if @carbrand.update(carbrand_params)
        format.html { redirect_to @carbrand, notice: 'Carbrand was successfully updated.' }
        format.json { render :show, status: :ok, location: @carbrand }
      else
        format.html { render :edit }
        format.json { render json: @carbrand.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carbrands/1
  # DELETE /carbrands/1.json
  def destroy
    @carbrand.destroy
    respond_to do |format|
      format.html { redirect_to carbrands_url, notice: 'Carbrand was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_carbrand
      @carbrand = Carbrand.find(params[:id])
    end

    def is_admin
      if current_user.admin
        true
      else
        respond_to do |format|
            format.html { redirect_to root_path, notice: "Votre n'avez pas les droits d'acces"  }
            format.json { render json: @carbrand.errors, status: :unprocessable_entity }
        end
    end
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def carbrand_params
      params.require(:carbrand).permit(:name)
    end
end
