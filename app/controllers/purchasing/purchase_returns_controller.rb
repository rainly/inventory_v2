class Purchasing::PurchaseReturnsController < ApplicationController
  before_filter :authenticate
  before_filter :assign_tab

  def index
    @search = current_company.purchase_returns.search(params[:search])
    @purchase_returns = @search.paginate(:page => params[:page])
  end
  
  def show
    @purchase_return = current_company.purchase_returns.find(params[:id])
  end
  
  def new
    @purchase_return = current_company.purchase_returns.new
    @suppliers = current_company.suppliers.all(:order => "name", :include => :profile)
    @purchase_order = current_company.purchase_orders.all(:order => "number")
    @purchase_return.entries.build
  end
  
  def create
    @purchase_return = current_company.purchase_returns.new(params[:purchase_return])
    if @purchase_return.save
      flash[:notice] = "Successfully created purchase return."
      redirect_to [:purchasing, @purchase_return]
    else
      @suppliers = current_company.suppliers.all(:order => "name")
      @purchase_order = current_company.purchase_orders.all(:order => "number")
      render :action => 'new'
    end
  end
  
  def edit
    @purchase_return = current_company.purchase_returns.find(params[:id])
    @suppliers = current_company.suppliers.all(:order => "name")
    @purchase_order = current_company.purchase_orders.all(:order => "number")
    @purchase_return.entries.build
  end
  
  def update
    @purchase_return = current_company.purchase_returns.find(params[:id])
    if @purchase_return.update_attributes(params[:purchase_return])
      flash[:notice] = "Successfully updated purchase return."
      redirect_to [:purchasing, @purchase_return]
    else
      render :action => 'edit'
      @suppliers = current_company.suppliers.all(:order => "name")
      @purchase_order = current_company.purchase_orders.all(:order => "number")
    end
  end
  
  def destroy
    @purchase_return = current_company.purchase_returns.find(params[:id])
    @purchase_return.destroy
    flash[:notice] = "Successfully destroyed purchase return."
    redirect_to purchasing_purchase_returns_url
  end

  private
  def assign_tab
    @tab = 'transactions'
    @current = 'ptr'
  end
end
