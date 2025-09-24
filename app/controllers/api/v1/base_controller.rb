class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_admin_user!

  protected

  def render_success(data = {}, message = nil)
    render json: {
      success: true,
      message: message,
      data: data
    }
  end

  def render_error(errors, status = :unprocessable_entity)
    render json: {
      success: false,
      errors: errors
    }, status: status
  end
end
