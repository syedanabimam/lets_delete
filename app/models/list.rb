class List < ApplicationRecord
  include CustomDeletable

  has_many :items, dependent: :destroy
  accepts_nested_attributes_for :items

  validates :name, presence: true

  def self.with_at_least_one_soft_deleted_item
    List.all.select(&:items_available?)
  end

  def items_available?
    items.count.positive? && items.soft_deleted.any?
  end
end
