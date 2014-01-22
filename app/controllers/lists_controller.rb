class ListsController < ApplicationController
  before_filter :authenticate_user!, except: :shared
  before_action :find_list, only: [:show, :update, :destroy]

  # Shows all logged in user lists
  def index
    @lists  = current_user.lists.order('created_at desc')
    @list   = List.new
    @gifts  = current_user.gifts.all
  end

  # Creates list or redirect back to index page if invalid
  def create
    @list = current_user.lists.new(list_params)
    if @list.save
      redirect_to @list, notice: 'List was successfully created.'
    else
      redirect_to root_path, alert: 'List was not created, try again.'
    end
  end

  # Show individual list GET'/list/#id'
  def show
    @gift   = Gift.new
    @gifts  = @list.gifts.all
  end

  # Update List details
  def update
    if @list.update_attributes(list_params)
      redirect_to @list, notice: 'List was successfully updated.'
    else
      render :show
    end
  end

  # Delete list
  def destroy
    @list.destroy
    redirect_to root_path, notice: 'List was deleted.'
  end

  # Shared List action for public views
  def public
    @list = List.find_by public_hash: params[:public_hash]
  end

  private
  def list_params
    params.require(:list).permit(:name, :human_due_date)
  end

  def find_list
    @list = current_user.lists.find(params[:id])
  end
end
