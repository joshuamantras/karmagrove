class DonationsController < ApplicationController
  def index
    @donations = Donation.all
    @charities = {}
    @retailers = []
    @donations.each do |donation|
      @charities[donation.id] = Charity.find(donation.charity_id)
      if donation.purchase_id
        purchase = Purchase.find(donation.purchase_id)
        if purchase
          if Retailer.exists? purchase.retailer_id
            @retailers = Retailer.find purchase.retailer_id
          else
            @retailers = []
          end
        end
      end
    end

    respond_to do |format|
      format.html
    end
  end
  # index

  # batches/{batch_id}/donations/new.svg
  def new
    @disable_nav = true
    @disable_sidebar = true
    @batch_id = params[:batch_id]
    @batch = Batch.find(@batch_id)
    puts @batch_id
    charity_ids = BatchCharity.where(:batch_id => @batch_id).map {|batch_charity| batch_charity.charity_id }
    @charities = Charity.find(charity_ids)
    @product_id = Product.where(:name => "Karma Coin").first.id
    @purchase = Purchase.new(:product_id => @product_id,:batch_id => @batch_id, :retailer_id => 1)
    @purchase.save
    respond_to do |format|
      format.html
      format.svg  { render :qrcode => request.url.gsub('.svg','.html'), :unit => 10 }
    end
  end

end
# DonationsController

