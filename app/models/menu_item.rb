class MenuItem < ApplicationRecord
  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items

  has_one_attached :image

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :description, length: { maximum: 500 }
  validates :sort_order, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :available, -> { where(available: true) }
  scope :by_category, ->(category) { where(category: category) }
  scope :ordered, -> { order(:sort_order, :name) }

  before_validation :set_default_sort_order, on: :create

  def formatted_price
    price.to_f
  end

  private

  def set_default_sort_order
    self.sort_order ||= ((category&.menu_items&.maximum(:sort_order)) || 0) + 1
  end
end
