class CarmodelsController < ApplicationController
  before_action :set_carmodel, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:index, :show, :new, :create, :destroy]
  before_filter :is_admin, only: [:index, :show, :create, :new, :destroy]

  # GET /carmodels
  # GET /carmodels.json
  def index
    @carmodels = Carmodel.all
  end

  # GET /carmodels/1
  # GET /carmodels/1.json
  def show
  end

  # GET /carmodels/new
  def new
    @carmodel = Carmodel.new
  end

  # GET /carmodels/1/edit
  def edit
  end

  # POST /carmodels
  # POST /carmodels.json
  def create
    @carmodel = Carmodel.new(carmodel_params)

    respond_to do |format|
      if @carmodel.save
        format.html { redirect_to @carmodel, notice: 'Carmodel was successfully created.' }
        format.json { render :show, status: :created, location: @carmodel }
      else
        format.html { render :new }
        format.json { render json: @carmodel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carmodels/1
  # PATCH/PUT /carmodels/1.json
  def update
    respond_to do |format|
      if @carmodel.update(carmodel_params)
        format.html { redirect_to @carmodel, notice: 'Carmodel was successfully updated.' }
        format.json { render :show, status: :ok, location: @carmodel }
      else
        format.html { render :edit }
        format.json { render json: @carmodel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carmodels/1
  # DELETE /carmodels/1.json
  def destroy
    @carmodel.destroy
    respond_to do |format|
      format.html { redirect_to carmodels_url, notice: 'Carmodel was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_carmodel
      @carmodel = Carmodel.find(params[:id])
    end

    def is_admin
      if current_user.admin
        true
      else
        respond_to do |format|
            format.html { redirect_to root_path, notice: "Votre n'avez pas les droits d'acces"  }
            format.json { render json: @carmodel.errors, status: :unprocessable_entity }
        end
    end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def carmodel_params
      params.require(:carmodel).permit(:brand_id, :name, :year)
    end
end
