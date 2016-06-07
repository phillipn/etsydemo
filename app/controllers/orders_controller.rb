class OrdersController < ApplicationController
  before_action :authenticate_user!

  # GET /orders
  # GET /orders.json
  def sales
    @orders = Order.include(:listing).where(seller_id: current_user.id).paginate(page: params[:page])
  end

  def purchases
    @orders = Order.include(:listing).where(buyer_id: current_user.id).paginate(page: params[:page])
  end

  # GET /orders/new
  def new
    @order = Order.new
    @listing = Listing.find(params[:listing_id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @listing = Listing.find(params[:listing_id])
    @seller = @listing.user

    @order.listing_id = @listing.id
    @order.buyer_id = current_user.id
    @order.seller_id = @seller.id

    Stripe.api_key = ENV["STRIPE_API_KEY"]
    token = params[:stripeToken]

    if address_present && !existing_order
      begin
        charge = Stripe::Charge.create(
                :amount => (@listing.price * 100).floor,
                :currency => "usd",
                :card => token
                )
      rescue Stripe::CardError => e
        flash[:danger] = e.message
      end
      
      transfer = Stripe::Transfer.create(
            :amount => (@listing.price * 95).floor,
            :currency => "usd",
            :recipient => @seller.recipient
            )
    end

    respond_to do |format|
      if @order.save
        format.html { redirect_to '/',  notice: "Order created!" }    
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:address, :city, :state)
    end

    def existing_order
      Order.dup_check(params[:listing_id])
    end

    def address_present
      params[:order][:address].present? && params[:order][:state].present? && params[:order][:city].present?
    end
end
