class ValidationsController < ApplicationController
  before_action :set_validation, only: [:show, :edit, :update, :destroy]
  before_filter :is_admin, only: [:show, :edit, :destroy, :index]

  # GET /validations
  # GET /validations.json
  def index
    @validations = Validation.all
  end

  # GET /validations/1
  # GET /validations/1.json
  def show
  end

  # GET /validations/new
  def new
    @validation = Validation.new
  end

  # GET /validations/1/edit
  def edit
  end

  # POST /validations
  # POST /validations.json
  def create
    @validation = Validation.new(validation_params)

    respond_to do |format|
      if @validation.save
        format.html { redirect_to @validation, notice: 'Validation was successfully created.' }
        format.json { render :show, status: :created, location: @validation }
      else
        format.html { render :new }
        format.json { render json: @validation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /validations/1
  # PATCH/PUT /validations/1.json
  def update
@val= Validation.new(validation_params)
    if @validation.code == @val.code_token
      @validation.update_attribute :validated, true
      @coin1 = Coin.new
      @coin1.user_id = @validation.driver_id
      @coin1.comment1 = "Validation bid #{@validation.bid_id}"
      @coin1.save
respond_to do |format|
        format.html { redirect_to user_path(current_user.id), notice: 'Trajet validé, merci' }
        format.json { render :show, status: :ok, location: @validation }
      end
      else
        respond_to do |format|
        format.html { redirect_to user_path(current_user.id), notice: 'Impossible de valider le trajet, merci de vérifier le code' }
        format.json { render json: @validation.errors, status: :unprocessable_entity }
    end
    end
  end

  # DELETE /validations/1
  # DELETE /validations/1.json
  def destroy
    @validation.destroy
    respond_to do |format|
      format.html { redirect_to validations_url, notice: 'Validation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_validation
      @validation = Validation.find(params[:id])
    end

    def is_admin
      if current_user.admin
        true
      else
        respond_to do |format|
            format.html { redirect_to root_path, notice: "Votre n'avez pas les droits d'acces"  }
            format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def validation_params
      params.require(:validation).permit(:bid_id, :driver_id, :pass_id, :code, :validated, :code_token, :bid_date)
    end
end
