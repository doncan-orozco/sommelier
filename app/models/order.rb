class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :menu_items, through: :order_items

  validates :table_name, presence: true
  validates :status, inclusion: { in: %w[pending preparing ready delivered] }
  validates :order_number, uniqueness: true, allow_blank: true

  before_create :set_order_number
  after_update :broadcast_status_change, if: :saved_change_to_status?

  scope :active, -> { where.not(status: "delivered") }
  scope :by_status, ->(status) { where(status: status) }
  scope :recent, -> { order(created_at: :desc) }

  def calculate_total!
    self.total_amount = order_items.sum { |item| item.quantity * item.unit_price }
    save!
  end

  def total_items
    order_items.sum(:quantity)
  end

  def status_color
    case status
    when "pending" then "text-orange-600 bg-orange-100"
    when "preparing" then "text-blue-600 bg-blue-100"
    when "ready" then "text-green-600 bg-green-100"
    when "delivered" then "text-gray-600 bg-gray-100"
    else "text-gray-600 bg-gray-100"
    end
  end

  def formatted_time
    created_at.strftime("%H:%M")
  end

  private

  def set_order_number
    self.order_number = "ORD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(3).upcase}"
  end

  def broadcast_status_change
    # This will be used for real-time updates later
    Rails.logger.info "Order #{order_number} status changed to #{status}"
  end
end
