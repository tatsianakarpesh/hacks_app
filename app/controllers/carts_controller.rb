class CartsController < ApplicationController
  before_action :set_cart
  before_action :set_cart_items, only: [:show]

  def show
    # If we have restored items, flash their details
    if flash[:restored_items]
      flash.now[:notice] = "Restored #{flash[:restored_items]} items to your cart"
    end
  end

  def clear_all
    if @cart && @cart.cart_items.any?
      # Store complete car information
      session[:cleared_cart_items] = @cart.cart_items.map do |item|
        car = item.car
        {
          car_id: car.id,
          make: car.make,
          model: car.model,
          year: car.year,
          price: car.price,
          created_at: Time.current
        }
      end

      items_count = @cart.cart_items.size
      @cart.cart_items.destroy_all

      redirect_to cart_path, notice: "Cart has been cleared (#{items_count} items). " +
        "#{view_context.button_to 'Undo', restore_cart_path,
           method: :post,
           class: 'btn btn-link',
           style: 'display: inline; padding: 0; border: none; color: #0d6efd; text-decoration: underline;'}"
    else
      redirect_to cart_path, alert: "Cart is already empty."
    end
  end

  def restore
    if session[:cleared_cart_items].present?
      restored_count = 0

      session[:cleared_cart_items].each do |item_data|
        # Only restore if the car still exists
        if Car.exists?(item_data[:car_id])
          @cart.cart_items.create(car_id: item_data[:car_id])
          restored_count += 1
        end
      end

      session.delete(:cleared_cart_items)
      flash[:restored_items] = restored_count
      redirect_to cart_path, notice: "Successfully restored #{restored_count} items to your cart!"
    else
      redirect_to cart_path, alert: "No recently cleared items to restore."
    end
  end

  private

  def set_cart
    @cart = Cart.find_by(id: session[:cart_id])
    unless @cart
      @cart = Cart.create
      session[:cart_id] = @cart.id
    end
  end

  def set_cart_items
    @cart_items = @cart.cart_items.includes(:car).order('cars.make ASC, cars.model ASC')
  end
end
