class MenuController < ApplicationController
  def index
    @categories = Category.active
                         .includes(:menu_items)
                         .where(menu_items: { available: true })
                         .ordered
                         .distinct

    @menu_items = MenuItem.includes(:category, image_attachment: :blob)
                         .available
                         .joins(:category)
                         .where(categories: { active: true })
                         .ordered

    # Group items by category for easier rendering
    @items_by_category = @menu_items.group_by(&:category)

    # Featured items for carousel (latest 3 items with images)
    @featured_items = MenuItem.includes(:category, image_attachment: :blob)
                             .available
                             .joins(:category)
                             .where(categories: { active: true })
                             .limit(3)
                             .ordered
  end
end
