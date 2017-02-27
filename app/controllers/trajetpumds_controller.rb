class TrajetpumdsController < ApplicationController
  before_action :set_trajetpumd, only: [:show, :edit, :update, :destroy],except:[:annulerresa, :confirm, :reserver]
  before_filter :authenticate_user!, only: [:confirm, :new, :create]
  before_filter :isnotfull, only: [:confirm]
  before_filter :isreservable, only: [:confirm]

  include CarrierWave::MiniMagick
  # GET /trajetpumds
  # GET /trajetpumds.json
  def index
  @trajetpumds= Trajetpumd.all

    @aroundpickershash = Gmaps4rails.build_markers(@trajetpumds) do |trajetpumds, marker|
      marker.lat trajetpumds.driver_lat
      marker.lng trajetpumds.driver_lon
    end
  end



  def search
    @searchlistdrive = Shop.where(isdrive: true)
    @shopidlist = @searchlistdrive.map{ |x| x.id }
    @aroundpickers=[]
    @par=params[:custom_address]
    if @par == nil || @par == ""
      if current_user
        @lati=current_user.latitude
        @longi=current_user.longitude
      else
        @client=request.location
        @lati=@client.latitude
        @longi=@client.longitude
      end
    else
      @client=Geocoder.coordinates(@par)
      @lati=@client[0]
      @longi=@client[1]
    end

    User.where(driver:true).each do |driver|
        disttodriver= Geocoder::Calculations.distance_between([@lati,@longi], [driver.latitude,driver.longitude], :units => :km).round(2)
      if disttodriver < 5
        @aroundpickers << [driver,disttodriver]
      end
    end
    @aroundpickers.sort_by{|t| t[1]}
    if @aroundpickers.size > 25
    @aroundpickers = @aroundpickers[0,25]
    end

    @trajetsactifs=[]
    @pickers=[]
    @pickerscoord=[]
    @pickersavatars=[]
    @pickersdates=[]
    @trajetsdata=[]
    # first item is current user
    @pickers << 0
    @trajetsdata << "C'est vous ;)"
    @pickerscoord << [@lati,@longi]
    if current_user
      @pickersavatars << "../.."+current_user.avatar.marker.url
    else
      @pickersavatars << "#{Rails.root}/public/img/avataruser/marker_defaultavatar.png"
    end

    # search each shop by driver
    @aroundpickers.each do |picker|
      @shop=[]
      Trajetpumd.isactive.where(driver_id:picker[0].id).each do |trajet|
        @shop << trajet.shop_id
      end
      @shop.uniq!
      # create marker each shop of driver
      @shop.each do |shop|
        i=Trajetpumd.isactive.where(shop_id:shop).where(driver_id:picker[0].id).order(:do_at).reverse.first
            @listtrajetpicker= render_to_string(partial: "infobulle", :locals=> {:@trajet=> i, :@lati => @lati, :@longi=> @longi}).gsub(/\n/, '')
            @trajetsdata << @listtrajetpicker
            @pickers << picker[0].id
            @pickerscoord << [picker[0].latitude,picker[0].longitude]
            @pickersavatars << "../.."+ Brand.find(Shop.find(shop).brand_id).minipic.marker.url
      end
    end
  end



  # GET /trajetpumds/1
  # GET /trajetpumds/1.json
  def show

  end

  # GET /trajetpumds/new
  def new
    @trajetpumd = Trajetpumd.new
  end

  # GET /trajetpumds/1/edit
  def edit

  end



  def destroy

  end


  def confirm
    @trajetid = params[:trajetid]
    @trajet=Trajetpumd.find(@trajetid)
    @driver= User.find(@trajet.driver_id)
    @shop= Shop.find(@trajet.shop_id)
    @do_at= @trajet.do_at

  end

  # POST /trajetpumds
  # POST /trajetpumds.json
  def create
    @trajet = Trajetpumd.new(trajetpumd_params)
    gettrajetinfos(@trajet)
    @trajet.driver_lon=@driver.longitude
    @trajet.driver_lat=@driver.latitude
    @trajet.shop_name=@shop.name
    if @trajet.save
      @resa = Resapumd.new()
      @resa.trajet_id=@trajet.id
      @resa.maxsac=@trajet.maxsac
      if @resa.save
        respond_to do |format|
        format.html { redirect_to root_url, notice: 'Picking créé' }
        format.json { render :root, status: :created, location: @trajet }
        end
      else
        respond_to do |format|
        format.html { render :new }
        format.json { render json: @trajet.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /trajetpumds/1
  # PATCH/PUT /trajetpumds/1.json
  def update
    respond_to do |format|
      if @trajetpumd.update(trajetpumd_params)
        format.html { redirect_to @trajetpumd, notice: 'Trajetpumd was successfully updated.' }
        format.json { render :show, status: :ok, location: @trajetpumd }
      else
        format.html { render :edit }
        format.json { render json: @trajetpumd.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trajetpumds/1
  # DELETE /trajetpumds/1.json
  def destroy
    @trajetpumd.destroy
    respond_to do |format|
      format.html { redirect_to trajetpumds_url, notice: 'Trajetpumd was successfully destroyed.' }
      format.json { head :no_content }
    end
  end




  def reserver
    require 'json'
    @trajet_id=params[:trajet_id].gsub(/[{:=value>"}]/,'').to_i
    @trajet = Trajetpumd.find(@trajet_id)
    @resa = Resapumd.where(trajet_id:@trajet_id).first
    @driver= User.find(@trajet.driver_id)
    @shop= Shop.find(@trajet.shop_id)
    @do_at= @trajet.do_at

    def createval
      @val= Validation.new
      @val.bid_id = @trajet_id
      @val.driver_id = @trajet.driver_id
      @val.pass_id= current_user.id
      code = SecureRandom.hex(10)
      code5 =""
      5.times do |i|
        code5 += code[i]
      end
      @val.code = code5
      @val.bid_date = @trajet.do_at.to_date
      @val.ispumdval = true
      @val.save
      ContactMailer.reservation_email(current_user, @bid).deliver_now
      ContactMailer.reservationP_email(current_user,@bid).deliver_now
     sendsms("#{@driver.phone}","PUMD: nouvelle reservation de #{current_user.username} ( #{current_user.phone} ) pour un picking (N° commande #{params[:refdrive]}) le #{l(@trajet.do_at, format:"%A %d %B")} à #{l(@trajet.do_at, format:"%H:%M")} à #{@shop.name}")
     sendsms("#{current_user.phone}","PUMD: Vous avez réservé pour un picking le #{l(@trajet.do_at, format:"%A %d %B")} à #{l(@trajet.do_at, format:"%H:%M")} à #{@shop.name} par #{@driver.username} (#{@driver.phone}) code validation: #{code5}")
    end
    def redir
      if @resa.save
       redirect_to root_url, notice: "Merveilleux! vos courses arriverons chez vous très vite... Enjoy PUMD ;)"
     else
       redirect_to root_url, notice: "OUps! :( il y a eu un problème... veuillez nous contacter "
      end
    end
    if @resa.drive1_size == nil
      @resa.drive1_size = params[:nbrsac]
      @resa.drive1_ref = params[:refdrive]
      @resa.drive1_userid = current_user.id
      @resa.driver1_subst = params[:substitution]
      createval()
      redir()
    elsif @resa.drive2_size == nil
      @resa.drive2_size = params[:nbrsac]
      @resa.drive2_ref = params[:refdrive]
      @resa.drive2_userid = current_user.id
      @resa.driver2_subst = params[:substitution]
      createval()
      redir()
    elsif @resa.drive3_size == nil
      @resa.drive3_size = params[:nbrsac]
      @resa.drive3_ref = params[:refdrive]
      @resa.drive3_userid = current_user.id
      @resa.driver3_subst = params[:substitution]
      createval()
      redir()
    elsif @resa.drive4_size == nil
      @resa.drive4_size = params[:nbrsac]
      @resa.drive4_ref = params[:refdrive]
      @resa.drive4_userid = current_user.id
      @resa.driver4_subst = params[:substitution]
      createval()
      redir()
    elsif @resa.drive5_size == nil
      @resa.drive5_size = params[:nbrsac]
      @resa.drive5_ref = params[:refdrive]
      @resa.drive5_userid = current_user.id
      @resa.driver5_subst = params[:substitution]
      createval()
      redir()
    elsif @resa.drive6_size == nil
      @resa.drive6_size = params[:nbrsac]
      @resa.drive6_ref = params[:refdrive]
      @resa.drive6_userid = current_user.id
      @resa.driver6_subst = params[:substitution]
      createval()
      redir()
    else
       redirect_to root_url, notice: "OUps! :( impossible de trouver votre reservation... veuillez nous contacter "
    end
  end



  def annulerresa
    @trajet=Trajetpumd.find(params[:trajet_id])
    @resa=Resapumd.where(trajet_id:params[:trajet_id]).first
    @driver= User.find(@trajet.driver_id)
    @shop= Shop.find(@trajet.shop_id)
    @do_at= @trajet.do_at
    iduser=params[:user_id].to_i

    def rmvval
      @val=Validation.where(ispumdval:true).where(bid_id: params[:trajet_id]).where(pass_id:params[:user_id]).first
      @val.destroy
    end
    def comannul
       sendsms("#{@driver.phone}","PUMD: annulation du picking de #{current_user.username}  (N° commande #{@refdrive}) du #{l(@trajet.do_at, format:"%A %d %B")} à #{l(@trajet.do_at, format:"%H:%M")} à #{@shop.name}")
    end
    def redir
      respond_to do |format|
        if @resa.save
          format.html { redirect_to root_path, notice: "Reservation annulée"  }
          format.json { render :root, status: :created, location: @resa }
        end
      end
    end

        if @resa.drive1_userid == iduser
            @resa.drive1_size = nil
            @refdrive=@resa.drive1_ref
            @resa.drive1_ref = nil
            @resa.drive1_userid = nil
            @resa.driver1_subst = nil
            rmvval()
            comannul()
            redir()

          elsif @resa.drive2_userid == iduser
            @resa.drive2_size = nil
            @refdrive=@resa.drive2_ref
            @resa.drive2_ref = nil
            @resa.drive2_userid = nil
            @resa.driver2_subst = nil
            rmvval()
            comannul()
            redir()
          elsif @resa.drive3_userid == iduser
            @resa.drive3_size = nil
            @refdrive=@resa.drive3_ref
            @resa.drive3_ref = nil
            @resa.drive3_userid = nil
            @resa.driver3_subst = nil
            rmvval()
            comannul()
            redir()
          elsif @resa.drive4_userid == iduser
            @resa.drive4_size = nil
            @refdrive=@resa.drive4_ref
            @resa.drive4_ref = nil
            @resa.drive4_userid = nil
            @resa.driver4_subst = nil
            rmvval()
            comannul()
            redir()
          elsif @resa.drive5_userid == iduser
            @resa.drive5_size = nil
            @refdrive=@resa.drive5_ref
            @resa.drive5_ref = nil
            @resa.drive5_userid = nil
            @resa.driver5_subst = nil
            rmvval()
            comannul()
            redir()
          elsif @resa.drive6_userid == iduser
            @resa.drive6_size = nil
            @refdrive=@resa.drive6_ref
            @resa.drive6_ref = nil
            @resa.drive6_userid = nil
            @resa.driver6_subst = nil
            rmvval()
            comannul()
            redir()
          else
            respond_to do |format|
              format.html { redirect_to user_path(current_user.id), notice: "Nous ne pouvons pas vous rembourser. Contacter nous"  }
              format.json { render json: @resa.errors, status: :unprocessable_entity }
            end
        end

  end




  private


  def sendsms(desti,mess)
    require 'rubygems'
    require 'twilio-ruby'

    formatnumber(desti)
    if @dest != nil

    client = Twilio::REST::Client.new ENV["TWILIO_KEY"], ENV["TWILIO_SECRET"]

    from = "+33644601039" # Your Twilio number
    client.account.messages.create(
        :from => from,
        :to => @dest,
        :body => mess
      )
    end
  end

  def formatnumber (phonenum)
    if phonenum !=nil
      if phonenum[0]== "0"
        phonenum[0]=="+33"
        @dest=phonenum
      elsif phonenum[0]== "+" && phonenum.size == 12
        @dest=phonenum
      else
        @dest=nil
      end
    else
      @dest= nil
    end
  end



    # Use callbacks to share common setup or constraints between actions.
    def set_trajetpumd
      @trajetpumd = Trajetpumd.find(params[:id])
    end

    def annulable
      settrajet = Trajetpumd.find(idtrajet)
      if (DateTime.now+3.hours) > settrajet.do_at
        respond_to do |format|
          format.html { redirect_to root_path, notice: 'Annulation impossible à moins de 3h du picking - arrangez-vous avec le picker' }
          format.json { head :no_content }
        end
      else
        true
      end
    end

    def isnotfull
      @resa=Resapumd.where(trajet_id:params[:trajetid]).first
      if @resa.drive1_userid == nil || @resa.drive2_userid == nil || @resa.drive3_userid == nil || @resa.drive4_userid == nil || @resa.drive5_userid == nil || @resa.drive6_userid == nil
        return true
        else
          redirect_to trajetpumds_search_path, notice:"Picking complet"
      end
    end

    def isreservable
      @trajet=Trajetpumd.find(params[:trajetid])
      if (DateTime.now+2.5.hours) < @trajet.do_at
         return true
       else
         redirect_to trajetpumds_search_path, notice:"Trop tard pour commander ce picking"
      end
    end

    def gettrajetinfos (trajet)
      @driver= User.find(trajet.driver_id)
      @shop= Shop.find(trajet.shop_id)
      @do_at= trajet.do_at
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trajetpumd_params
      params.require(:trajetpumd).permit(:driver_id, :shop_id, :regulier, :shop_name, :driver_uname, :driver_lat, :driver_lon, :do_at, :maxsac)
    end
end
