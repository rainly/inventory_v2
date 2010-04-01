class ItemTransfersController < ApplicationController
  before_filter :authenticate
  before_filter :assign_tab
  def index
    @item_transfers = current_company.item_transfers.all
  end
  
  def show
    @item_transfer = ItemTransfer.find(params[:id])
  end
  
  def new
    @item_transfer = current_company.item_transfers.new
    @item_transfer.number = ItemTransfer.suggested_number(current_company)
  end
  
  def create
    @item_transfer = current_company.item_transfers.new(params[:item_transfer])
    if @item_transfer.save
      flash[:notice] = "Successfully created item transfer."
      redirect_to @item_transfer
    else
      render :action => 'new'
    end
  end
  
  def edit
    @item_transfer = ItemTransfer.find(params[:id])
  end
  
  def update
    @item_transfer = ItemTransfer.find(params[:id])
    if @item_transfer.update_attributes(params[:item_transfer])
      flash[:notice] = "Successfully updated item transfer."
      redirect_to @item_transfer
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @item_transfer = ItemTransfer.find(params[:id])
    @item_transfer.destroy
    flash[:notice] = "Successfully destroyed item transfer."
    redirect_to item_transfers_url
  end

  private
  def assign_tab
    @tab = 'transactions'
  end
end
