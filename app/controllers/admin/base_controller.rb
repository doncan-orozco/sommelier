class Admin::BaseController < ApplicationController
  before_action :authenticate_admin_user!
  layout 'admin'

  private

  def set_admin_flash(type, message)
    flash[type] = message
  end
end
