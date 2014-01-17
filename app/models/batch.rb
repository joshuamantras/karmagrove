class Batch < ActiveRecord::Base
  attr_accessible :batch_name, :sales, :workflow_state, :state
  has_many :batch_products
  has_many :batch_charities
  has_many :batch_charity_payments
  # todo .. has many through ... 
  # has_many_through :purchases batch_products 

  include Workflow

  workflow do
    state :open do
      event :close, transition_to: :closed
      event :cancel, transition_to: :cancelled
    end
    state :closed do
      event :cancel, transition_to: :cancelled
    end
    state :cancelled do
      event :resume, transition_to: :open
    end

    state :shipped
  end

  def initialize(arg1,arg2=nil)
    super(arg1,arg2)
    @batch = self
    self.state = "open"
    self.save
  end

  def close
     @batch.state = "closed"
     @batch.save
  end

  def new_purchase(product_id)
    Purchase.new(:batch_id => self.id, :product_id => product_id)
  end

  def map_of_charity_ids
    map_of_charities = {}
    self.batch_charities.each do |charity|
      map_of_charities[charity.id] =0
    end
    map_of_charities
  end
  
  def pay_charities
    map_of_charities_and_amounts = {}
    self.batch_charities.each do |charity|
      map_of_charities_and_amounts[charity.id] =0  
    end
    map_of_charities
  end


  # def close(allowed_to_close = true)
  #   # Let it close! ...
  #   self.state = self.current_state
  #   self.save
  #   halt unless allowed_to_close
  # end
end

