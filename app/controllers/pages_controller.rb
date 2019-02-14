class PagesController < ApplicationController
  def trash
    @soft_deleted_lists = List.soft_deleted
  end
end
