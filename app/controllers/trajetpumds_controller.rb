class TrajetpumdsController < ApplicationController
  before_action :set_trajetpumd, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:confirm]
  require "stripe"
  Stripe.api_key = ENV['stripe_api_key']
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
    @trajetsactifs=[]
    @pickers=[]
    @pickerscoord=[]
    @pickersavatars=[]
    @pickersdates=[]
    @trajetsdata=[]
    @shopidlist.count.times do |item|
      n=0
      if @pickers.count <=26
        Trajetpumd.trajetsactifs.where(shop_id:"#{@shopidlist[item]}").order(:do_at).reverse.each do |i|
           driver=User.find(i.driver_id)
           if current_user
             disttodriver= Geocoder::Calculations.distance_between([current_user.latitude,current_user.longitude], [driver.latitude,driver.longitude], :units => :km).round(2)
            else
             @client=request.location
             disttodriver= Geocoder::Calculations.distance_between([@client.latitude,@client.longitude], [driver.latitude,driver.longitude], :units => :km).round(2)
           end
           if disttodriver < 5
             if n==0
               @trajetsactifs << i
               @pickers << 0
               @trajetsdata << "C'est vous ;)"
               if current_user
                 @pickerscoord << [current_user.latitude,current_user.longitude]
                 @pickersavatars << "../.."+current_user.avatar.marker.url
               else
                 @pickerscoord << [@client.latitude,@client.longitude]
                 @pickersavatars << "#{Rails.root}/public/img/avataruser/defaultavatar.png"
               end
             end
             @pickers << driver.id
             @pickerscoord << [driver.latitude,driver.longitude]
             @pickersavatars << "../.."+ Brand.find(Shop.find(@shopidlist[item]).brand_id).minipic.marker.url
             n+=1
           end
        end
      end
    end
    @pickers= @pickers.uniq
    @pickerscoord= @pickerscoord.uniq
    @pickersavatars= @pickersavatars.uniq
    @pickers.each do |picker|
      @listtrajetpicker=""
      @trajetsactifs.each do |trajet|
        if trajet.driver_id == picker
          @listtrajetpicker= @listtrajetpicker + render_to_string(partial: "infobulle", :locals=> {:@trajet=> trajet}).gsub(/\n/, '')
        end
      end
      if @listtrajetpicker != ""
        @trajetsdata << @listtrajetpicker
      end
    end
  end

  def reserver
    require 'json'
    @trajet_id=params[:trajet_id].gsub(/[{:=value>"}]/,'').to_i
    @trajet = Trajetpumd.find(@trajet_id)

    @resa = Resapumd.where(trajet_id:@trajet_id).first
    def transaction
      @trans=Transaction.new
      @trans.user_id = current_user.id
      @trans.tvalue = -3.0
      @trans.comment = "Réservation de picking"
      @trans.trajetpumd_id = @trajet_id
      @trans.save!
    end
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
      # ContactMailer.reservation_email(current_user, @bid).deliver_now
      # ContactMailer.reservationP_email(current_user,@bid).deliver_now
      # gettrajetinfos(@trajet)
      # sendsms("#{@driver.phone}","PUMD: nouvelle reservation de #{current_user.username} ( #{current_user.phone} ) pour un picking (N° commande #{params[:refdrive]}) le #{l(@trajet.do_at, format:"%A %d %B")} à #{l(@trajet.do_at, format:"%H:%M")} à #{@shop.name}")
      # sendsms("#{current_user.phone}","PUMD: Vous avez réservé pour un picking le #{l(@trajet.do_at, format:"%A %d %B")} à #{l(@trajet.do_at, format:"%H:%M")} à #{@shop.name} par #{@driver.username} (#{@driver.phone}) code validation: #{code5}")
    end
    if @resa.drive1_size == nil
      transaction()
      @resa.drive1_size = params[:nbrsac]
      @resa.drive1_ref = params[:refdrive]
      @resa.drive1_userid = current_user.id
      @resa.driver1_subst = params[:substitution]
      createval()
      respond_to do |format|
        if @resa.save
          format.html { redirect_to root_path, notice: "Reservation enregistrée"  }
          format.json { render :root, status: :created, location: @resa }
        end
      end
    elsif @resa.drive2_size == nil
      transaction()
      @resa.drive2_size = params[:nbrsac]
      @resa.drive2_ref = params[:refdrive]
      @resa.drive2_userid = current_user.id
      @resa.driver2_subst = params[:substitution]
      createval()
      respond_to do |format|
        if @resa.save
          format.html { redirect_to root_path, notice: "Reservation enregistrée"  }
          format.json { render :root, status: :created, location: @resa }
          end
      end
    elsif @resa.drive3_size == nil
      transaction()
      @resa.drive3_size = params[:nbrsac]
      @resa.drive3_ref = params[:refdrive]
      @resa.drive3_userid = current_user.id
      @resa.driver3_subst = params[:substitution]
      createval()
      respond_to do |format|
        if @resa.save
          format.html { redirect_to root_path, notice: "Reservation enregistrée"  }
          format.json { render :root, status: :created, location: @resa }
        end
      end
    elsif @resa.drive4_size == nil
      transaction()
      @resa.drive4_size = params[:nbrsac]
      @resa.drive4_ref = params[:refdrive]
      @resa.drive4_userid = current_user.id
      @resa.driver4_subst = params[:substitution]
      createval()
      respond_to do |format|
        if @resa.save
          format.html { redirect_to root_path, notice: "Reservation enregistrée"  }
          format.json { render :root, status: :created, location: @resa }
          end
      end
    elsif @resa.drive5_size == nil
      transaction()
      @resa.drive5_size = params[:nbrsac]
      @resa.drive5_ref = params[:refdrive]
      @resa.drive5_userid = current_user.id
      @resa.driver5_subst = params[:substitution]
      createval()
      respond_to do |format|
        if @resa.save
          format.html { redirect_to root_path, notice: "Reservation enregistrée"  }
          format.json { render :root, status: :created, location: @resa }
          end
      end
    elsif @resa.drive6_size == nil
      transaction()
      @resa.drive6_size = params[:nbrsac]
      @resa.drive6_ref = params[:refdrive]
      @resa.drive6_userid = current_user.id
      @resa.driver6_subst = params[:substitution]
      createval()
      respond_to do |format|
        if @resa.save
          format.html { redirect_to root_path, notice: "Reservation enregistrée"  }
          format.json { render :root, status: :created, location: @resa }
        end
      end
    else
      respond_to do |format|
          format.html { redirect_to trajetpumds_search_path, notice: "Picking complet"  }
          format.json { render json: @resa.errors, status: :unprocessable_entity }
      end
    end
  end

  def annulerresa(idtrajet,iduser)
    @resa=Resapumd.where(trajet_id:istrajet).first
    def rmvtransaction
      @trans=Transaction.where(trajetpumd_id: idtrajet).where(user_id:iduser).first
      @trans.destroy
    end
    def rmvval
      @val=Validation.where(ispumdval:true).where(bid_id: idtrajet).where(pass_id:current_user.id).first
      @val.destroy
    end
    def comannul
      @trajet=Trajetpumd.find(idtrajet)
      gettrajetinfos(@trajet)
      sendsms("#{@driver.phone}","PUMD: annulation du picking de #{current_user.username}  (N° commande #{params[:refdrive]}) du #{l(@trajet.do_at, format:"%A %d %B")} à #{l(@trajet.do_at, format:"%H:%M")} à #{@shop.name}")
    end
    if @resa.drive1_userid == iduser
      @resa.drive1_size = nil
      @resa.drive1_ref = nil
      @resa.drive1_userid = nil
      @resa.driver1_subst = nil
      rmvval()
      rmvtransaction()
      comannul()
      respond_to do |format|
        if @resa.save
          format.html { redirect_to root_path, notice: "Reservation annulée"  }
          format.json { render :root, status: :created, location: @resa }
        end
      end
    elsif @resa.drive2_userid == iduser
      @resa.drive2_size = nil
      @resa.drive2_ref = nil
      @resa.drive2_userid = nil
      @resa.driver2_subst = nil
      rmvval()
      rmvtransaction()
      comannul()
      respond_to do |format|
        if @resa.save
          format.html { redirect_to root_path, notice: "Reservation annulée"  }
          format.json { render :root, status: :created, location: @resa }
        end
      end
    elsif @resa.drive3_userid == iduser
      @resa.drive3_size = nil
      @resa.drive3_ref = nil
      @resa.drive3_userid = nil
      @resa.driver3_subst = nil
      rmvval()
      rmvtransaction()
      comannul()
      respond_to do |format|
        if @resa.save
          format.html { redirect_to root_path, notice: "Reservation annulée"  }
          format.json { render :root, status: :created, location: @resa }
        end
      end
    elsif @resa.drive4_userid == iduser
      @resa.drive4_size = nil
      @resa.drive4_ref = nil
      @resa.drive4_userid = nil
      @resa.driver4_subst = nil
      rmvval()
      rmvtransaction()
      comannul()
      respond_to do |format|
        if @resa.save
          format.html { redirect_to root_path, notice: "Reservation annulée"  }
          format.json { render :root, status: :created, location: @resa }
        end
      end
    elsif @resa.drive5_userid == iduser
      @resa.drive5_size = nil
      @resa.drive5_ref = nil
      @resa.drive5_userid = nil
      @resa.driver5_subst = nil
      rmvval()
      rmvtransaction()
      comannul()
      respond_to do |format|
        if @resa.save
          format.html { redirect_to root_path, notice: "Reservation annulée"  }
          format.json { render :root, status: :created, location: @resa }
        end
      end
    elsif @resa.drive6_userid == iduser
      @resa.drive6_size = nil
      @resa.drive6_ref = nil
      @resa.drive6_userid = nil
      @resa.driver6_subst = nil
      rmvval()
      rmvtransaction()
      comannul()
      respond_to do |format|
        if @resa.save
          format.html { redirect_to root_path, notice: "Reservation annulée"  }
          format.json { render :root, status: :created, location: @resa }
        end
      end
    else
      respond_to do |format|
          format.html { redirect_to user_path(current_user.id), notice: "Nous ne trouvons pas la réservation pour ce picking. Contacter nous"  }
          format.json { render json: @resa.errors, status: :unprocessable_entity }
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


  def confirm
    @trajetid = params[:trajetid]
    @trajet=Trajetpumd.find(@trajetid)
    gettrajetinfos(@trajet)
    @resa=Resapumd.where(trajet_id:@trajetid).first

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

  def gettrajetinfos (trajet)
    @driver= User.find(trajet.driver_id)
    @shop= Shop.find(trajet.shop_id)
    @do_at= trajet.do_at

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



    # Never trust parameters from the scary internet, only allow the white list through.
    def trajetpumd_params
      params.require(:trajetpumd).permit(:driver_id, :shop_id, :regulier, :shop_name, :driver_uname, :driver_lat, :driver_lon, :do_at, :maxsac)
    end
end
