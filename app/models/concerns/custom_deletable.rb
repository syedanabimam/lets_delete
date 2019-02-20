module CustomDeletable
  extend ActiveSupport::Concern

  included do
    default_scope { where(deleted_at: nil) }
    scope :soft_deleted, -> { unscope(where: :deleted_at).where.not(deleted_at: nil) }
  end

  def soft_delete
    update_attribute(:deleted_at, Time.current) if has_attribute? :deleted_at
    soft_delete_associated!
  end

  def recover
    update_attribute(:deleted_at, nil) if has_attribute? :deleted_at
  end

  def soft_delete_associated!
    self.class.reflect_on_all_associations.map do |associated|
      if associated.class == ActiveRecord::Reflection::HasManyReflection && send(associated.name).any?
        send(associated.name).update_all(deleted_at: Time.current) if associated.active_record.column_names.include? 'deleted_at'
      end
    end
  end
end
