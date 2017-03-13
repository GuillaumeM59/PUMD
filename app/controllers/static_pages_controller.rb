class StaticPagesController < ApplicationController
  before_filter :authenticate_user!, only: [:tdb]



  def home
    @bid = Bid.new
    @client = set_ip
    @clientip = set_ip.ip
    if current_user
    if current_user.driver
    @waitval = Validation.where("(driver_id = #{current_user.id} AND validated = false)").where("bid_date < ?", "#{Date.today}")
    end
    end
    if current_user
      @aroundshop = Shop.near([current_user.latitude, current_user.longitude], 30, :units => :km)
    else
      @aroundshop = Shop.near([@client.latitude, @client.longitude], 30, :units => :km)
    end

    @aroundlastbids= []
    @shopidlist = @aroundshop.map{ |x| x.id }
    @shopidlist.count.times do |item|
       Bid.where(shop_id:"#{@shopidlist[item]}").order(:go_at).reverse.each do |i|
         if i.go_at >= Date.today
         @aroundlastbids << i
       end
       end
       @filterShop = true
   @filteredshop = Shop.where(brand_id: params[:brand_id]).order(:name)
    end
    @bid = Bid.new
  end
  def ccm
  end

  def qui
  end

  def help
  end

  def mentionslegales
  end

  def cgv
  end

  def prix
  end

  def presse
  end

  def contact
    @message = Message.new
  end

  def sendquestion
   @message = Message.new(message_params)
   ContactMailer.contact_email(@message).deliver_now
    respond_to do |format|
       format.html { redirect_to root_path, notice: 'Message Envoyé' }
       format.json { render json: static_pages_contact_path, status: :created, location: static_pages_contact_path }
    end
  end

  def dailyrenew
    Autorenew.daily
  end

  def tdb
      @user=current_user
      dob = @user.dob
      now = Time.now.utc.to_date
      @age =now.year - @user.dob.year - (@user.dob.change(:year => now.year) > now ? 1 : 0)
      @trajetsresas=[]
      @resas=Resapumd.where('drive1_userid=? OR drive2_userid=? OR drive3_userid=? OR drive4_userid=? OR drive5_userid=? OR drive6_userid=?', "#{@user.id}", "#{@user.id}", "#{@user.id}", "#{@user.id}", "#{@user.id}", "#{@user.id}").reverse
      if @resas.count !=0
        @resas.each do |i|
            if i.drive1_userid==@user.id
              n=1
            elsif i.drive2_userid==@user.id
              n=2
            elsif i.drive3_userid==@user.id
              n=3
            elsif i.drive4_userid==@user.id
              n=4
            elsif i.drive5_userid==@user.id
              n=5
            else
              n=6
            end
            @trajetsresas << [Trajetpumd.find(i.trajet_id),i,n]
        end
      end
      @trans=Transaction.where(user_id:@user.id).order(:created_at).reverse
      @trajetsidisdriver=[]
      @mespickingresas=[]
      Trajetpumd.where(driver_id:@user.id).reverse.each do |t|
        @trajetsidisdriver << t
      end
      x=0
      @trajetsidisdriver.count.times do |i|
        if x < 20
          datareserve = []
          f=Resapumd.find(@trajetsidisdriver[i].id)
          if f.drive1_userid != nil
            datareserve << [f.drive1_userid, f.drive1_ref, f.drive1_size, f.driver1_subst]
            x +=1
          end
          if f.drive2_userid != nil
            datareserve << [f.drive2_userid, f.drive2_ref, f.drive2_size, f.driver2_subst]
            x +=1
          end
          if f.drive3_userid != nil
            datareserve << [f.drive3_userid, f.drive3_ref, f.drive3_size, f.driver3_subst]
            x +=1
          end
          if f.drive4_userid != nil
            datareserve << [f.drive4_userid, f.drive4_ref, f.drive4_size, f.driver4_subst]
            x +=1
          end
          if f.drive5_userid != nil
            datareserve << [f.drive5_userid, f.drive5_ref, f.drive5_size, f.driver5_subst]
            x +=1
          end
          if f.drive6_userid != nil
            datareserve << [f.drive6_userid, f.drive6_ref, f.drive6_size, f.driver6_subst]
            x +=1
          end
            @mespickingresas << [@trajetsidisdriver[i], datareserve]
        end
      end




  end



private

  def message_params
    params.require(:message).permit(:prenom, :objet, :email, :contenu) # permit keys
  end
 def set_ip
   if current_user
     @aroundshop = Shop.near([current_user.latitude, current_user.longitude], 30, :units => :km)
   end
   @client = request.location
 end

end
