class TransactionsController < ApplicationController
  before_action :authenticate_user!



  # GET /transactions/new
  def new
    @brandid= params[:brand_id]
    @trajetid= params[:trajet_id]
    @nbrsac= params[:nbrsac]
    @refdrive= params[:refdrive]
    @substitution= params[:substitution]
    gon.client_token = generate_client_token

  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @brandid= params[:brand_id].gsub(/[{:=value>"}]/,'').to_i
    @trajetid= params[:trajet_id].gsub(/[{:=value>"}]/,'').to_i
    @nbrsac= params[:nbrsac].gsub(/[{:=value>"}]/,'').to_i
    @refdrive= params[:refdrive]
    @substitution= params[:substitution]
    @trajet=Trajetpumd.find(@trajetid)
    @driver= User.find(@trajet.driver_id)

    @result = Braintree::Transaction.sale(
    :amount => '3.00',
:options => {
:submit_for_settlement => true
})
       if @result.success?
         @trans=Transaction.new
         @trans.user_id = current_user.id
         @trans.tvalue = -3.0
         @trans.comment = "Réservation de picking"
         @trans.trajetpumd_id = @trajetid
         @trans.braintree_tid = @result.transaction.id
         @trans.save!
         @trans=Transaction.new
         @trans.user_id = @driver.id
         @trans.tvalue = 0
         @trans.comment = "En attente de validation de picking"
         @trans.trajetpumd_id = @trajetid
         @trans.braintree_tid = @result.transaction.id
         @trans.save!
         redirect_to reserver_trajet_path(brand_id:@brand_id, trajet_id:@trajetid, nbrsac:@nbrsac, refdrive:@refdrive, substitution:@substitution)
       else
         flash[:alert] = "Problème pendant la transaction :( Merci de recommencer"
         gon.client_token = generate_client_token
         render :new
       end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

def cancelling
  @trajet=Trajetpumd.find(params[:trajet_id])
  @resa=Resapumd.where(trajet_id:params[:trajet_id])
  @trans=Transaction.where(trajetpumd_id:params[:trajet_id]).where(user_id:params[:user_id]).first
  @trans2=Transaction.where(trajetpumd_id:params[:trajet_id]).where(user_id:@trajet.driver_id).first
  @userid=params[:user_id]
  if @trans!=nil && @trans2!=nil && @trajet.id!=nil && @resa.count !=0
      @trans2.destroy
      @trans.tvalue = 0
      @trans.comment = "Annulation de la demande de picking"
      if @trans.save
        redirect_to trajetpumds_annulerresa_path(trajet_id:params[:trajet_id], user_id:@userid)
      end
  else
    redirect_to root_path, notice:"Impossible de trouver les transactions - veuillez réessayer ou nous contacter"
  end
end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def generate_client_token
      Braintree::ClientToken.generate
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


    # Never trust parameters from the scary internet, only allow the white list through.
end
