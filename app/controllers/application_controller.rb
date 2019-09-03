class ApplicationController < ActionController::Base
  class ApiLimitError < StandardError; end

  skip_forgery_protection if: -> { SessionLoader.new(request).has_api_authentication? }
  before_action :reset_current_user
  before_action :set_current_user
  before_action :normalize_search
  before_action :api_check
  before_action :set_variant
  before_action :track_only_param
  before_action :enable_cors
  after_action :reset_current_user
  layout "default"

  rescue_from Exception, :with => :rescue_exception

  protected

  def self.rescue_with(*klasses, status: 500)
    rescue_from *klasses do |exception|
      render_error_page(status, exception)
    end
  def show_moderation_notice?
    #CurrentUser.can_approve_posts? && (cookies[:moderated].blank? || Time.at(cookies[:moderated].to_i) < 20.hours.ago)
	false
  end

  def enable_cors
    response.headers["Access-Control-Allow-Origin"] = "*"
  end

  def track_only_param
    if params[:only]
      RequestStore[:only_param] = params[:only].split(/,/)
    end
  end

  def api_check
    return if CurrentUser.is_anonymous? || request.get? || request.head?

    if CurrentUser.user.token_bucket.nil?
      TokenBucket.create_default(CurrentUser.user)
      CurrentUser.user.reload
    end

    throttled = CurrentUser.user.token_bucket.throttled?
    headers["X-Api-Limit"] = CurrentUser.user.token_bucket.token_count.to_s

    if throttled
      raise ApiLimitError, "too many requests"
    end
  end

  def rescue_exception(exception)
    case exception
    when ActiveRecord::QueryCanceled
      render_error_page(500, exception, message: "The database timed out running your query.")
    when ActionController::BadRequest
      render_error_page(400, exception)
    when SessionLoader::AuthenticationFailure
      render_error_page(401, exception)
    when ActionController::InvalidAuthenticityToken, ActionController::UnpermittedParameters, ActionController::InvalidCrossOriginRequest
      render_error_page(403, exception)
    when User::PrivilegeError
      render_error_page(403, exception, template: "static/access_denied", message: "Access denied")
    when ActiveRecord::RecordNotFound
      render_error_page(404, exception, message: "That record was not found.")
    when ActionController::RoutingError
      render_error_page(405, exception)
    when ActionController::UnknownFormat, ActionView::MissingTemplate
      render_error_page(406, exception, message: "#{request.format.to_s} is not a supported format for this page")
    when Danbooru::Paginator::PaginationError
      render_error_page(410, exception)
    when Post::SearchError
      render_error_page(422, exception)
    when ApiLimitError
      render_error_page(429, exception)
    when NotImplementedError
      render_error_page(501, exception, message: "This feature isn't available: #{exception.message}")
    when PG::ConnectionBad
      render_error_page(503, exception, message: "The database is unavailable. Try again later.")
    else
      render_error_page(500, exception)
    end
  end

  def render_error_page(status, exception, message: exception.message, template: "static/error", format: request.format.symbol)
    @exception = exception
    @expected = status < 500
    @message = message.encode("utf-8", { invalid: :replace, undef: :replace })
    @backtrace = Rails.backtrace_cleaner.clean(@exception.backtrace)
    format = :html unless format.in?(%i[html json xml js atom])

    # if InvalidAuthenticityToken was raised, CurrentUser isn't set so we have to use the blank layout.
    layout = CurrentUser.user.present? ? "default" : "blank"

    DanbooruLogger.log(@exception, expected: @expected)
    render template, layout: layout, status: status, formats: format
  rescue ActionView::MissingTemplate
    render "static/error", layout: layout, status: status, formats: format
  end

  def set_current_user
    SessionLoader.new(request).load
  end

  def reset_current_user
    CurrentUser.user = nil
    CurrentUser.ip_addr = nil
    CurrentUser.safe_mode = false
    CurrentUser.root_url = root_url.chomp("/")
  end

  def set_variant
    request.variant = params[:variant].try(:to_sym)
  end

  User::Roles.each do |role|
    define_method("#{role}_only") do
      if !CurrentUser.user.send("is_#{role}?") || CurrentUser.user.is_banned? || IpBan.is_banned?(CurrentUser.ip_addr)
        raise User::PrivilegeError
      end
    end
  end

  # Remove blank `search` params from the url.
  #
  # /tags?search[name]=touhou&search[category]=&search[order]=
  # => /tags?search[name]=touhou
  def normalize_search
    return unless request.get? || request.head?
    params[:search] ||= ActionController::Parameters.new

    deep_reject_blank = lambda do |hash|
      hash.reject { |k, v| v.blank? || (v.is_a?(Hash) && deep_reject_blank.call(v).blank?) }
    end
    nonblank_search_params = deep_reject_blank.call(params[:search])

    if nonblank_search_params != params[:search]
      params[:search] = nonblank_search_params
      redirect_to url_for(params: params.except(:controller, :action, :index).permit!)
    end
  end

  def search_params
    params.fetch(:search, {}).permit!
  end
end
