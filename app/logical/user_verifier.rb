# Checks whether a new account seems suspicious and should require email verification.

class UserVerifier
  extend Memoist

  attr_reader :current_user, :request

  # current_user is the user creating the new account, not the new account itself.
  def initialize(current_user, request)
    @current_user, @request = current_user, request
  end

  def requires_verification?
    return false if !Danbooru.config.new_user_verification?
    return false if ip_address.is_local?

    # we check for IP bans first to make sure we bump the IP ban hit count
    is_ip_banned? || is_logged_in? || is_recent_signup? || is_proxy?
  end

  def initial_level
    if requires_verification?
      User::Levels::RESTRICTED
    else
      User::Levels::MEMBER
    end
  end

  def log!
    DanbooruLogger.add_attributes("user_verifier", to_h)
  end

  private

  def ip_address
    @ip_address ||= Danbooru::IpAddress.new(request.remote_ip)
  end

  def is_logged_in?
    !current_user.is_anonymous?
  end

  def is_recent_signup?(age: 24.hours)
    subnet_len = ip_address.ipv4? ? 24 : 64
    subnet = "#{ip_address}/#{subnet_len}"

    User.where("last_ip_addr <<= ?", subnet).where("created_at > ?", age.ago).exists?
  end

  def is_ip_banned?
    IpBan.hit!(:partial, ip_address.to_s)
  end

  def is_proxy?
    ip_address.is_proxy?
  end

  def to_h
    { is_ip_banned: is_ip_banned?, is_logged_in: is_logged_in?, is_recent_signup: is_recent_signup?, is_proxy: is_proxy? }
  end

  memoize :is_ip_banned?, :is_proxy?, :is_recent_signup?
end
