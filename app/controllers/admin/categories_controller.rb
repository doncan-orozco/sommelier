class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [ :show, :edit, :update, :destroy ]

  def index
    @categories = Category.includes(:menu_items).ordered
  end

  def show
    @menu_items = @category.menu_items.includes(image_attachment: :blob).ordered
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to admin_categories_path, notice: "Category was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "Category was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.menu_items.any?
      redirect_to admin_categories_path, alert: "Cannot delete category with menu items. Please move or delete the items first."
    else
      @category.destroy
      redirect_to admin_categories_path, notice: "Category was successfully deleted."
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description, :sort_order, :active)
  end
end
