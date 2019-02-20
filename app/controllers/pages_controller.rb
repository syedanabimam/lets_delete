class PagesController < ApplicationController
  def trash
    @soft_deleted_lists     = List.soft_deleted
    @non_soft_deleted_lists = List.with_at_least_one_soft_deleted_item
  end
end
