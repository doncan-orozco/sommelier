class Admin::KitchenController < Admin::BaseController
  def index
    @orders = Order.includes(order_items: [:menu_item])
                  .active
                  .recent

    @stats = {
      pending: @orders.by_status('pending').count,
      preparing: @orders.by_status('preparing').count,
      ready: @orders.by_status('ready').count,
      total: @orders.count
    }

    # Auto-refresh data every 15 seconds
    response.headers['Refresh'] = '15' if request.format.html?
  end
end
