class List < ApplicationRecord
  include CustomDeletable

  has_many :items, dependent: :destroy
  accepts_nested_attributes_for :items

  validates :name, presence: true
end
