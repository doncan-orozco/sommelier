class Category < ApplicationRecord
  has_many :menu_items, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :sort_order, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }
  scope :with_items, -> { joins(:menu_items).distinct }
  scope :ordered, -> { order(:sort_order, :name) }

  before_validation :set_default_sort_order, on: :create

  private

  def set_default_sort_order
    self.sort_order ||= (Category.maximum(:sort_order) || 0) + 1
  end
end
