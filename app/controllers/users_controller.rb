class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:index, :new, :create, :destroy, :show]
  before_filter :is_admin, only: [:index]


  # GET /users
  # GET /users.json
  def index

      @users = User.all
      @hash = Gmaps4rails.build_markers(@users) do |user, marker|
        marker.lat user.latitude
        marker.lng user.longitude
      end

  end
  def indexonlogin
    if current_user
      redirect_to action: "show", id: current_user.id
    else
      redirect_to root_path
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @nextpickings=Trajetpumd.isactive.where(:driver_id => @user.id).order(:do_at).limit(5)
    if current_user
    if current_user.id == @user.id
      if current_user.driver
      @waitval = Validation.where("(driver_id = #{current_user.id} AND validated = false)").where("bid_date < ?", "#{Date.today}")
      end
      end
    else
          @client = request.location
    end
      dob = @user.dob
      now = Time.now.utc.to_date
      @age =now.year - @user.dob.year - (@user.dob.change(:year => now.year) > now ? 1 : 0)
    @hash = Gmaps4rails.build_markers(@user) do |user, marker|
      marker.lat user.latitude
      marker.lng user.longitude
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    dob = @user.dob
    now = Time.now.utc.to_date
    @age =now.year - @user.dob.year - (@user.dob.change(:year => now.year) > now ? 1 : 0)
    @slide = params[:slide]
    def resource

    @resource ||= @user

    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.avatar = :default_url
    respond_to do |format|
      if @user.save
        if params[:user][:avatar].present?
          render :crop
        else
          format.html { redirect_to @user, notice: 'Vous avez été inscrit, Bienvenue' }
          format.json { render :show, status: :created, location: @user }
        end
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @slide = params[:user][:slide].to_s
    if params[:user][:current_password].nil?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
      if @user.update_without_password(user_params)
        respond_to do |format|
          format.html {
            if params[:user][:avatar].present?
              render :crop
            else
              redirect_to @user, notice: 'Votre profil a été modifié.'
            end
            }
          format.json { render :show, status: :ok, location: @user }
        end
      else
        respond_to do |format|
          format.html { redirect_to edit_user_path(@user, :slide => params[:user][:slide]) }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
      if @user.update_with_password(user_params)
        respond_to do |format|
          format.html {
            if params[:user][:avatar].present?
              render :crop
            else
              redirect_to @user, notice: 'Votre profil a été modifié.'
            end
          }
          format.json { render :show, status: :ok, location: @user }
        end
      else
        respond_to do |format|
          format.html { render :edit}
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

  end


  # AJAX CHECK USERNAME ALREADY EXIST
  def checkname
     if User.where('username = ?', params[:username]).count == 0
       render :nothing => true, :status => 200
     else
       render :nothing => true, :status => 409
     end
     return
   end

  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
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
    def user_params
      params.require(:user).permit(:id, :username,
        :admin, :nom, :prenom,:dob, :comment, :subscribe,
         :city, :latitude, :longitude, :adress, :zipcode,
         :gender, :slide, :driver, :cbrand_id, :cmodel_id,
         :carsize, :email, :phone, :xp, :avatar, :password,
         :password_confirmation, :current_password,
          :crop_x, :crop_y, :crop_w, :crop_h)
    end




end
