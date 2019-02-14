class ListsController < ApplicationController
  before_action :set_list, only: %i[show edit update destroy soft_delete restore]

  def index
    @lists = List.active
  end

  def show
  end

  def new
    @list = List.new
  end

  def edit
  end

  def create
    @list = List.new(list_params)

    if @list.save
      redirect_to @list, notice: 'List was successfully created.'
    else
      render :new
    end
  end

  def update
    if @list.update(list_params)
      redirect_to @list, notice: 'List was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @list.destroy
    redirect_to root_path, notice: 'List was successfully destroyed.'
  end

  def soft_delete
    @list.soft_delete
    redirect_to root_path, notice: 'List was successfully soft deleted.'
  end

  def restore
    @list.recover
    redirect_to trash_path, notice: 'List was successfully restored.'
  end

  private

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name)
  end
end
