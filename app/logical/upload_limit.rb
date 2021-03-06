class UploadLimit
  extend Memoist

  INITIAL_POINTS = 5000
  MAXIMUM_POINTS = 500_000
  APPEAL_COST = 1
  DELETION_COST = 1

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def limited?
    !user.can_upload_free? && used_upload_slots >= upload_slots
  end

  def maxed?
    user.upload_points >= MAXIMUM_POINTS
  end

  def used_upload_slots
    pending_count = user.posts.pending.count
    appealed_count = user.post_appeals.pending.count
    early_deleted_count = user.posts.deleted.where("created_at >= ?", Danbooru.config.moderation_period.ago).count

    pending_count + (early_deleted_count * DELETION_COST) + (appealed_count * APPEAL_COST)
  end

  def free_upload_slots
    upload_slots - used_upload_slots
  end

  def upload_slots
    upload_level + 50
  end

  def upload_level
    UploadLimit.points_to_level(user.upload_points)
  end

  def approvals_on_current_level
    (user.upload_points - UploadLimit.level_to_points(upload_level)) / 50
  end

  def approvals_for_next_level
    UploadLimit.points_for_next_level(upload_level) / 5
  end

  def update_limit!(post, incremental: true)
    return if user.can_upload_free?

    user.with_lock do
      if incremental
        user.upload_points += UploadLimit.upload_value(user.upload_points, post.is_deleted)
        user.upload_points = user.upload_points.clamp(0, MAXIMUM_POINTS)
        user.save!
      else
        user.update!(upload_points: UploadLimit.points_for_user(user))
      end
    end
  end

  def self.points_for_user(user)
    points = INITIAL_POINTS

    uploads = user.posts.where(is_pending: false).order(id: :asc).pluck(:is_deleted)
    uploads.each do |is_deleted|
      points += upload_value(points, is_deleted)
      points = points.clamp(0, MAXIMUM_POINTS)

      # warn "slots: %2d, points: %3d, value: %2d" % [UploadLimit.points_to_level(points) + 5, points, UploadLimit.upload_value(level, is_deleted)]
    end

    points
  end

  def self.upload_value(current_points, is_deleted)
    if is_deleted
      level = points_to_level(current_points)
      -1 * (points_for_next_level(level) / 3.0).round.to_i
    else
      10
    end
  end

  def self.points_for_next_level(level)
    100 + 20 * [level - 10, 0].max
  end

  def self.points_to_level(points)
    level = 0

    loop do
      points -= points_for_next_level(level)
      break if points < 0
      level += 1
    end

    level
  end

  def self.level_to_points(level)
    (1..level).map do |n|
      points_for_next_level(n - 1)
    end.sum
  end
end
