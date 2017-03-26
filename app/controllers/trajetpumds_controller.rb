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
    @shopstosort=[]
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
      @client=Geocoder.coordinates(@par + "france")
      @lati=@client[0]
      @longi=@client[1]
    end
    @searchlistdrive.each do |shop|
        disttoshop= Geocoder::Calculations.distance_between([@lati,@longi], [shop.latitude,shop.longitude], :units => :km).round(2)
        if disttoshop <30
        @shopstosort << [shop,disttoshop]
      end
      @aroundshops= @shopstosort.sort do |a,b|
        a[1] <=> b[1]
      end
    end


    User.where(driver:true).each do |driver|
        disttodriver= Geocoder::Calculations.distance_between([@lati,@longi], [driver.latitude,driver.longitude], :units => :km).round(2)
      if disttodriver < 20
        @aroundpickers << [driver,disttodriver]
      end
    end
    @aroundpickers.sort_by{|t| t[1]}
    if @aroundpickers.size > 25
      @aroundpickers = @aroundpickers[0,25]
    end

    @shops=[]
    @shopscoord=[]
    @shopsavatars=[]
    @trajetsactifs=[]
    @pickers=[]
    @pickerscoord=[]
    @pickersavatars=[]
    @pickersdates=[]
    @trajetsdata=[]
    @trajetids=[]
    # first item is current user
    @pickers << 0
    @trajetsdata << "C'est vous ;)"
    @pickerscoord << [@lati,@longi]
    @pickersavatars << "../.." + view_context.image_path('/img/gmap-flag-pump-55px.png')


    # showshops around user
    @aroundshops.each do |shoparray|
            shop= shoparray[0]
            @shops << shop.id
            @shopscoord << [shop.latitude,shop.longitude]
            @shopsavatars << "../.."+ shop.brand.minipic.marker.url
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
            @pickersavatars << "../.."+ i.user.avatar.marker.url
      end
      Trajetpumd.isactive.where(driver_id:picker[0].id).order(:do_at).reverse.each do |t|
        sommesacs(t.resapumd)
        placerestante(t.resapumd)
        @trajetids << [t, @placesrestantes]
      end
    end
  end



  # GET /trajetpumds/1
  # GET /trajetpumds/1.json
  def show
    @trajet=  @trajetpumd
    sommesacs(@trajet.resapumd)
    placerestante(@trajet.resapumd)
    @nextpickings=Trajetpumd.isactive.where(:driver_id => @trajet.user.id).order(:do_at).limit(5)
    @nextpickers=Trajetpumd.isactive.where(:shop_id => @trajet.shop.id).order(:do_at).limit(7)
    @user=@trajet.user
    dob = @user.dob
    now = Time.now.utc.to_date
    @age =now.year - @user.dob.year - (@user.dob.change(:year => now.year) > now ? 1 : 0)
    if current_user
      @lati=current_user.latitude
      @longi=current_user.longitude
    else
      @client=request.location
      @lati=@client.latitude
      @longi=@client.longitude
    end
    @acts=[]
    @actscoord=[]
    @actsavatars=[]
    @acts << 0
    @actscoord << [@lati,@longi]
    if current_user
      @actsavatars << current_user.avatar.marker.url
    else
      @actsavatars << "#{Rails.root}/public/img/avataruser/marker_defaultavatar.png"
    end
    @acts << 1
    @actscoord << [@trajet.shop.latitude,@trajet.shop.longitude]
    @actsavatars << @trajet.shop.brand.minipic.marker.url
     if current_user!=@user
        @acts << 2
        @actscoord << [@trajet.user.latitude,@trajet.user.longitude]
        @actsavatars << @trajet.user.avatar.marker.url
      end
  end

  # GET /trajetpumds/new
  def new
    @trajetpumd = Trajetpumd.new
  end

  # GET /trajetpumds/1/edit
  def edit
    @trajet=  @trajetpumd
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
    if @trajet.regulier
      did= @trajet.driver_id
      sid= @trajet.shop_id
      nsacs= @trajet.maxsac
      dayn= @trajet.do_at.wday
      ttime= @trajet.do_at.strftime("%H:%M")
      check= Routine.where(driver_id:did,shop_id:sid,day_num:dayn,at_time:ttime )
      if check.size == 0
        @r=Routine.new()
        @r.driver_id = did
        @r.shop_id = sid
        @r.nsacs = nsacs
        @r.day_num = dayn
        @r.at_time = ttime
        @r.activated = true
        @r.save!
      else
        @r=check.first
        @r.nsacs = nsacs
        @r.activated = true
        @r.save!
      end
    end

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
        format.html { redirect_to trajetpumd_path(@trajetpumd), notice: 'Trajetpumd was successfully updated.' }
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
       redirect_to root_url, notice: "Merveilleux! vos courses arriverons chez vous très vite... Enjoy PUMP ;)"
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

  def sommesacs(resa)
    sac=0
    if resa.drive1_size!=nil
      sac+=resa.drive1_size
    end
    if resa.drive2_size!=nil
      sac+=resa.drive2_size
    end
    if resa.drive3_size!=nil
      sac+=resa.drive3_size
    end
    if resa.drive4_size!=nil
      sac+=resa.drive4_size
    end
    if resa.drive5_size!=nil
      sac+=resa.drive5_size
    end
    @sommesacs= sac
  end

  def placerestante(res)
    @places=0
    @max= res.maxsac
    if res.drive6_size == nil
      @sac=0
      if res.drive1_size!=nil
        @sac+=res.drive1_size
      end
      if res.drive2_size!=nil
        @sac+=res.drive2_size
      end
      if res.drive3_size!=nil
        @sac+=res.drive3_size
      end
      if res.drive4_size!=nil
        @sac+=res.drive4_size
      end
      if res.drive5_size!=nil
        @sac+=res.drive5_size
      end
     @places= @max - @sac
    end
    @placesrestantes = @places
  end


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
      @driver= trajet.user
      @shop= trajet.shop
      @do_at= trajet.do_at
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trajetpumd_params
      params.require(:trajetpumd).permit(:driver_id, :shop_id, :regulier, :shop_name, :driver_uname, :driver_lat, :driver_lon, :do_at, :maxsac)
    end
end
