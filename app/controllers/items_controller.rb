class ItemsController < ApplicationController
  before_action :set_item, only: %i[show edit update destroy soft_delete]
  before_action :set_list

  def show
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    @item = @list.items.build(item_params)

    if @item.save
      redirect_to root_path, notice: 'Item was successfully created.'
    else
      render :new
    end
  end

  def update
    if @item.update(item_params)
      redirect_to root_path, notice: 'Item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to root_path, notice: 'Item was successfully destroyed.'
  end

  def soft_delete
    @item.soft_delete
    redirect_to root_path, notice: 'Item was successfully soft deleted.'
  end

  def restore
    @item = Item.soft_deleted.find(params[:id])
    @item.recover
    redirect_to trash_path, notice: 'Item was successfully restored.'
  end

  private

  def set_list
    @list = List.find(params[:list_id])
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name)
  end
end
