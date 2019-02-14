module CustomDeletable
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(deleted_at: nil) }
    scope :soft_deleted, -> { unscope(where: :deleted_at).where.not(deleted_at: nil) }
  end

  def soft_delete
    update_attribute(:deleted_at, Time.current) if has_attribute? :deleted_at
  end

  def recover
    update_attribute(:deleted_at, nil) if has_attribute? :deleted_at
  end
end
