class SessionLoader
  class AuthenticationFailure < StandardError; end

  attr_reader :session, :request, :params

  def initialize(request)
    @request = request
    @session = request.session
    @params = request.parameters
  end

  def login(name, password)
    user = User.find_by_name(name)

    if user.present? && user.authenticate_password(password)
      session[:user_id] = user.id
      session[:last_authenticated_at] = Time.now.utc.to_s

      UserEvent.build_from_request(user, :login, request)
      user.last_logged_in_at = Time.now
      user.last_ip_addr = request.remote_ip
      user.save!

      user
    elsif user.nil?
      nil # username incorrect
    else
      UserEvent.create_from_request!(user, :failed_login, request)
      nil # password incorrect
    end
  end

  def logout
    session.delete(:user_id)
    session.delete(:last_authenticated_at)
    return if CurrentUser.user.is_anonymous?
    UserEvent.create_from_request!(CurrentUser.user, :logout, request)
  end

  def load
    CurrentUser.user = User.anonymous
    CurrentUser.ip_addr = request.remote_ip

    if has_api_authentication?
      load_session_for_api
    elsif params[:signed_user_id]
      load_param_user(params[:signed_user_id])
    elsif session[:user_id]
      load_session_user
    end

    set_statement_timeout
    update_last_logged_in_at
    update_last_ip_addr
    set_time_zone
    set_country
    set_safe_mode
    initialize_session_cookies
    CurrentUser.user.unban! if CurrentUser.user.ban_expired?
  ensure
    DanbooruLogger.add_session_attributes(request, session, CurrentUser.user)
  end

  def has_api_authentication?
    request.authorization.present? || params[:login].present? || (params[:api_key].present? && params[:api_key].is_a?(String))
  end

  private

  def set_statement_timeout
    timeout = CurrentUser.user.statement_timeout
    ActiveRecord::Base.connection.execute("set statement_timeout = #{timeout}")
  end

  def load_session_for_api
    if request.authorization
      authenticate_basic_auth
    elsif params[:login].present? && params[:api_key].present?
      authenticate_api_key(params[:login], params[:api_key])
    else
      raise AuthenticationFailure
    end
  end

  def authenticate_basic_auth
    credentials = ::Base64.decode64(request.authorization.split(' ', 2).last || '')
    login, api_key = credentials.split(/:/, 2)
    DanbooruLogger.add_attributes("request.params", login: login)
    authenticate_api_key(login, api_key)
  end

  def authenticate_api_key(name, key)
    user, api_key = User.find_by_name(name)&.authenticate_api_key(key)
    raise AuthenticationFailure if user.blank?
    update_api_key(api_key)
    raise User::PrivilegeError if !api_key.has_permission?(request.remote_ip, request.params[:controller], request.params[:action])
    CurrentUser.user = user
  end

  # XXX use rails 6.1 signed ids (https://github.com/rails/rails/blob/6-1-stable/activerecord/CHANGELOG.md)
  def load_param_user(signed_user_id)
    session[:user_id] = Danbooru::MessageVerifier.new(:login).verify(signed_user_id)
    load_session_user
  end

  def load_session_user
    user = User.find_by_id(session[:user_id])
    CurrentUser.user = user if user
  end

  def update_last_logged_in_at
    return if CurrentUser.is_anonymous?
    return if CurrentUser.last_logged_in_at && CurrentUser.last_logged_in_at > 1.hour.ago
    CurrentUser.user.update_attribute(:last_logged_in_at, Time.now)
  end

  def update_last_ip_addr
    return if CurrentUser.is_anonymous?
    return if CurrentUser.user.last_ip_addr == @request.remote_ip
    CurrentUser.user.update_attribute(:last_ip_addr, @request.remote_ip)
  end

  def update_api_key(api_key)
    api_key.increment!(:uses, touch: :last_used_at)
    api_key.update!(last_ip_address: request.remote_ip)
  end

  def set_time_zone
    Time.zone = CurrentUser.user.time_zone
  end

  # Depends on Cloudflare
  # https://support.cloudflare.com/hc/en-us/articles/200168236-Configuring-Cloudflare-IP-Geolocation
  def set_country
    CurrentUser.country = request.headers["CF-IPCountry"]
  end

  def set_safe_mode
    safe_mode = request.host.match?(/safebooru/i) || params[:safe_mode].to_s.truthy? || CurrentUser.user.enable_safe_mode?
    CurrentUser.safe_mode = safe_mode
  end

  def initialize_session_cookies
    session.options[:expire_after] = 20.years
    session[:started_at] ||= Time.now.utc.to_s
  end
end
