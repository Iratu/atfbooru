module Deletable
  extend ActiveSupport::Concern

  class_methods do
    def deletable
      scope :active, -> { where(is_deleted: false) }
      scope :deleted, -> { where(is_deleted: true) }
      scope :undeleted, -> { where(is_deleted: false) }

      define_method(:soft_delete) do |**options|
        update(is_deleted: true, **options)
      end

      define_method(:soft_delete!) do |**options|
        update!(is_deleted: true, **options)
      end
    end
  end
end
