class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [:show, :update, :update_status]

  def index
    @orders = Order.includes(order_items: [:menu_item])
                  .recent

    @orders = @orders.by_status(params[:status]) if params[:status].present?
    @orders = @orders.page(params[:page]).per(20)

    @status_counts = {
      all: Order.count,
      pending: Order.by_status('pending').count,
      preparing: Order.by_status('preparing').count,
      ready: Order.by_status('ready').count,
      delivered: Order.by_status('delivered').count
    }
  end

  def show
  end

  def update
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: 'Order was successfully updated.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  def update_status
    if @order.update(status: params[:status])
      render json: {
        success: true,
        message: "Order ##{@order.order_number} marked as #{params[:status]}",
        new_status: @order.status,
        status_color: @order.status_color
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
    params.require(:order).permit(:status, :notes)
  end
end
