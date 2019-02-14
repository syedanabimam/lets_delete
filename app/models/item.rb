class Item < ApplicationRecord
  include CustomDeletable

  belongs_to :list
  validates :name, presence: true
end
