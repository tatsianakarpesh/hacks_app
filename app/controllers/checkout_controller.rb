class CheckoutController < ApplicationController
  def index
    @cart = current_cart

    if @cart.cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty"
      return
    end

    # Initialize checkout state
    @checkout_type = params[:checkout_type] || session[:checkout_type]
    session[:checkout_type] = @checkout_type

    if user_signed_in?
      # Pre-fill form with user data if available
      @order = {
        email: current_user.email,
        first_name: current_user.first_name,
        last_name: current_user.last_name,
        phone_number: current_user.phone_number
      }
    end
  end

  def process_order
    @cart = current_cart

    if @cart.cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty"
      return
    end

    # Process the order based on user type and input
    if order_params_valid?
      # Here you would typically:
      # 1. Create the order
      # 2. Process payment
      # 3. Clear the cart
      # 4. Send confirmation email

      # For now, just show success
      redirect_to order_confirmation_path
    else
      flash.now[:alert] = "Please fill in all required fields"
      render :index
    end
  end

  private

  def order_params_valid?
    params[:email].present? &&
    params[:first_name].present? &&
    params[:last_name].present? &&
    params[:phone_number].present?
  end

  def current_cart
    Cart.find_by(id: session[:cart_id])
  end
end
