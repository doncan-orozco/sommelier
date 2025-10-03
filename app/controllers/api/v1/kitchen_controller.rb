class Api::V1::KitchenController < Api::V1::BaseController
  def orders
    orders = Order.includes(order_items: [ :menu_item ])
                  .active
                  .recent

    orders_data = orders.map do |order|
      {
        id: order.id,
        order_number: order.order_number,
        table_name: order.table_name,
        status: order.status,
        notes: order.notes,
        total_amount: order.total_amount,
        formatted_time: order.formatted_time,
        items: order.order_items.map do |item|
          {
            name: item.menu_item.name,
            quantity: item.quantity,
            unit_price: item.unit_price
          }
        end
      }
    end

    render_success(orders_data)
  end
end
