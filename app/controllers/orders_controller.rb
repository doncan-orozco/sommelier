class OrdersController < ApplicationController
  before_action :set_order, only: [ :show, :update_status ]

  def new
    @order = Order.new
    @cart_items = params[:cart] ? JSON.parse(URI.decode_www_form_component(params[:cart])) : {}
    @menu_items = MenuItem.where(id: @cart_items.keys).includes(:category)
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      create_order_items
      render json: {
        success: true,
        message: "Order ##{@order.order_number} placed successfully!",
        order_id: @order.id,
        redirect_url: order_path(@order)
      }
    else
      render json: {
        success: false,
        errors: @order.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def show
    @order = Order.includes(order_items: [ :menu_item ]).find(params[:id])
  end

  def update_status
    if @order.update(status: params[:status])
      render json: {
        success: true,
        message: "Order ##{@order.order_number} marked as #{params[:status]}"
      }
    else
      render json: {
        success: false,
        errors: @order.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:table_name, :notes)
  end

  def create_order_items
    items_data = params[:items] || []

    items_data.each do |item_data|
      next unless item_data[:id].present? && item_data[:quantity].present?

      menu_item = MenuItem.find_by(id: item_data[:id])
      next unless menu_item

      @order.order_items.create!(
        menu_item: menu_item,
        quantity: item_data[:quantity].to_i,
        unit_price: menu_item.price
      )
    end

    @order.calculate_total!
  end
end
