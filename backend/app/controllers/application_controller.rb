class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection
  include Pagy::Method

  include Authentication

  before_action :set_csrf_cookie
  before_action :set_active_storage_url_options
  allow_unauthenticated_access only: %i[ csrf ]

  rescue_from ActionController::ParameterMissing,  with: :render_parameter_missing
  rescue_from ActionController::InvalidAuthenticityToken, with: :render_csrf_token_missing

  if Rails.env.test?
    protect_from_forgery with: :null_session
  else
    protect_from_forgery with: :exception
  end

  def csrf
    head :ok
  end

  private

  # Make Active Storage URLs (avatars, book attachments) use whichever host
  # the request actually arrived on. Lets clients reach uploaded files
  # regardless of how the user addresses the app (LAN IP, hostname, tunnel...).
  def set_active_storage_url_options
    ActiveStorage::Current.url_options = {
      host: request.host,
      port: request.optional_port,
      protocol: request.protocol
    }
  end

  def set_csrf_cookie
    cookie = {
      value: form_authenticity_token,
      same_site: :lax,
      secure: Rails.env.production? && ENV.fetch("FORCE_SSL", "true") == "true"
    }
    if Rails.env.production?
      domain = ENV.fetch("CSRF_COOKIE_DOMAIN", ".lumireader.app").presence
      cookie[:domain] = domain if domain
    end
    cookies["CSRF-TOKEN"] = cookie
  end

  def render_csrf_token_missing(exception)
    render_error(errors: exception.message, status: :unprocessable_content)
  end

  def render_parameter_missing(exception)
    render_error(errors: exception.message, status: :unprocessable_content)
  end

  def render_success(data: nil, message: "Operation finished successfully", status: :ok)
    render json: { status: "success", data: data, message: message }, status: status
  end

  def render_error(errors:, status: :unprocessable_content)
    render json: { status: "error", errors: Array.wrap(errors), message: nil }, status: status
  end
end
