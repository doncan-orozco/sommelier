class Admin::MenuItemsController < Admin::BaseController
  before_action :set_menu_item, only: [ :show, :edit, :update, :destroy, :toggle_availability ]

  def index
    @categories = Category.includes(:menu_items).ordered
    @menu_items = MenuItem.includes(:category, image_attachment: :blob).ordered
    @menu_items = @menu_items.where(category_id: params[:category_id]) if params[:category_id].present?
  end

  def show
  end

  def new
    @menu_item = MenuItem.new
    @categories = Category.active.ordered
  end

  def create
    @menu_item = MenuItem.new(menu_item_params)

    if @menu_item.save
      redirect_to admin_menu_items_path, notice: "Menu item was successfully created."
    else
      @categories = Category.active.ordered
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.active.ordered
  end

  def update
    if @menu_item.update(menu_item_params)
      redirect_to admin_menu_items_path, notice: "Menu item was successfully updated."
    else
      @categories = Category.active.ordered
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @menu_item.destroy
    redirect_to admin_menu_items_path, notice: "Menu item was successfully deleted."
  end

  def toggle_availability
    @menu_item.update(available: !@menu_item.available)
    redirect_to admin_menu_items_path, notice: "#{@menu_item.name} is now #{@menu_item.available? ? 'available' : 'unavailable'}."
  end

  private

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :description, :price, :category_id, :available, :sort_order, :image)
  end
end
