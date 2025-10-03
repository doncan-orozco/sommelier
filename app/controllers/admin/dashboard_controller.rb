class Admin::DashboardController < Admin::BaseController
  def index
    @stats = {
      total_categories: Category.count,
      total_menu_items: MenuItem.count,
      available_items: MenuItem.available.count,
      total_orders: Order.count,
      pending_orders: Order.by_status("pending").count,
      preparing_orders: Order.by_status("preparing").count,
      ready_orders: Order.by_status("ready").count,
      todays_orders: Order.where(created_at: Date.current.all_day).count,
      todays_revenue: Order.where(created_at: Date.current.all_day, status: "delivered").sum(:total_amount)
    }

    @recent_orders = Order.includes(:order_items, :menu_items)
                          .recent
                          .limit(10)
  end

  def stats
    render json: {
      pending: Order.by_status("pending").count,
      preparing: Order.by_status("preparing").count,
      ready: Order.by_status("ready").count,
      total_active: Order.active.count
    }
  end
end
