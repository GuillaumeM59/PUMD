class ChargesController < ApplicationController
  require "stripe"
  Stripe.api_key = ENV['stripe_api_key']

  def new
  end

  def create
    @amount = params[:amount]

    @amount = @amount.gsub('$', '').gsub(',', '')

    begin
      @amount = Float(@amount).round(2)
    rescue
      flash[:error] = 'Rechargement impossible: entrez une valeur en euro.'
      redirect_to new_charge_path
      return
    end

    @amount = (@amount * 100).to_i # Must be an integer!

    if @amount < 500
      flash[:error] = 'Rechargement impossible, montant minimum 10€'
      redirect_to new_charge_path
      return
    end

    Stripe::Charge.create(
      :amount => @amount,
      :currency => 'eur',
      :source => params[:stripeToken],
      :description => 'Rechargement cagnotte'
    )

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
    end
  end
