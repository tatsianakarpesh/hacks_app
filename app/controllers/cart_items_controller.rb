class CartItemsController < ApplicationController
  before_action :set_cart

  def create
    car = Car.find(params[:car_id])
    unless @cart.cars.include?(car)
      @cart.cart_items.create(car: car)
      flash[:notice] = "#{car.year} #{car.make} #{car.model} has been added to your cart!"
    else
      flash[:alert] = 'This car is already in your cart.'
    end
    redirect_back fallback_location: cars_path
  end

  def destroy
    cart_item = @cart.cart_items.find(params[:id])
    car = cart_item.car
    cart_item.destroy
    flash[:notice] = "#{car.year} #{car.make} #{car.model} has been removed from your cart."
    redirect_to cart_path
  end

  private

  def set_cart
    @cart = Cart.find_by(id: session[:cart_id])
    unless @cart
      @cart = Cart.create
      session[:cart_id] = @cart.id
    end
  end
end
