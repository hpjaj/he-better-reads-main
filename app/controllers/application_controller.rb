class ApplicationController < ActionController::API
  before_action :authenticate

  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end

  def authenticate
    !!set_current_user
  rescue ArgumentError => e
    render json: { error: e.message }, status: :unauthorized
  end

  def sign_out_current_user
    @current_user = nil
  end

private

  def set_current_user
    auth_header_present!

    @current_user = User.find_by!(id: user_id)
  end

  def auth_header_present!
    return if !!request.env.fetch("HTTP_AUTHORIZATION", "").scan(/Bearer/).flatten.first

    raise ArgumentError, '"Authorization: Bearer token" header is not present'
  end

  def user_id
    JWTAuth.decode!(token).dig('user_id')
  end

  def token
    request.env["HTTP_AUTHORIZATION"].scan(/Bearer (.*)$/).flatten.last
  end
end
