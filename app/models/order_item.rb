class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :menu_item

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than: 0 }

  before_validation :set_unit_price, on: :create
  after_save :update_order_total
  after_destroy :update_order_total

  def subtotal
    quantity * unit_price
  end

  private

  def set_unit_price
    self.unit_price = menu_item.price if menu_item && unit_price.blank?
  end

  def update_order_total
    order.calculate_total! if order
  end
end
