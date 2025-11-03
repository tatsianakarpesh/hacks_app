class CarsController < ApplicationController
  before_action :set_car, only: %i[ show ]
  before_action :deny_access, only: %i[ new create edit update destroy ]

  # GET /cars or /cars.json
  def index
    @cars = Car.all.includes(:cart_items)  # Add includes to optimize queries

    # Handle search
    if params[:search].present?
      search_term = params[:search].upcase
      @cars = @cars.where("UPPER(make) LIKE ? OR UPPER(model) LIKE ?", "%#{search_term}%", "%#{search_term}%")
    end

    # Filter by color
    @cars = @cars.where("UPPER(description) LIKE ?", "%#{params[:color].upcase}%") if params[:color].present?

    # Filter by year
    @cars = @cars.where(year: params[:year]) if params[:year].present?

    # Handle sorting (with default sort)
    @current_sort = params[:sort] || 'year_desc'
    @cars = case @current_sort
            when 'year_asc'
              @cars.order('year ASC, make ASC')
            when 'year_desc'
              @cars.order('year DESC, make ASC')
            when 'price_asc'
              @cars.order('price ASC, make ASC')
            when 'price_desc'
              @cars.order('price DESC, make ASC')
            else
              @cars.order('year DESC, make ASC')
            end

    # Get unique years for filter dropdown
    @available_years = Car.distinct.pluck(:year).sort.reverse

    # Get unique colors from descriptions
    @available_colors = %w[Red Blue Black White Silver Gray Green]

    # Apply pagination after sorting
    @cars = @cars.page(params[:page]).per(20)
  end

  # GET /cars/1 or /cars/1.json
  def show
  end

  # GET /cars/new
  def new
    deny_access
  end

  # GET /cars/1/edit
  def edit
    deny_access
  end

  # POST /cars
  def create
    deny_access
  end

  # PATCH/PUT /cars/1
  def update
    deny_access
  end

  # DELETE /cars/1
  def destroy
    deny_access
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car
      @car = Car.find(params[:id])
    end

    def deny_access
      redirect_to cars_path, alert: "Access denied. Users are not allowed to modify cars."
    end
end
