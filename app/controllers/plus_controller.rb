class PlusController < ApplicationController
  before_filter :authenticate, :except => [:search]
  before_filter :assign_tab
  before_filter :prepare_autocomplete, :only => [:new, :create, :edit, :update]
  load_and_authorize_resource

  def index
    @search = current_company.plus.search(params[:search])
    @plus = @search.paginate(:page => params[:page])
  end
  
  def show
    @plu = Plu.find(params[:id])
  end
  
  def new
    @plu = current_company.plus.new(:item_id => params[:item_id], :supplier_id => params[:supplier_id])
    @suppliers = current_company.suppliers.all(:order => :name)
  end
  
  def create
    @plu = current_company.plus.new(params[:plu])
    if @plu.save
      flash[:notice] = "Successfully created plu."
      redirect_to @plu
    else
      @suppliers = current_company.suppliers.all(:order => :name)
      render :action => 'new'
    end
  end
  
  def edit
    @suppliers = current_company.suppliers.all(:order => :name)
    @plu = Plu.find(params[:id])
  end
  
  def update
    @plu = Plu.find(params[:id])
    if @plu.update_attributes(params[:plu])
      flash[:notice] = "Successfully updated plu."
      redirect_to @plu
    else
      @suppliers = current_company.suppliers.all(:order => :name)
      render :action => 'edit'
    end
  end
  
  def destroy
    @plu = Plu.find(params[:id])
    @plu.destroy
    flash[:notice] = "Successfully destroyed plu."
    redirect_to plus_url
  end

  def search
    keyword = params[:term]
    if keyword.nil?
      {}
    else
      @plus = current_company.plus.code_or_item_name_or_item_code_like(keyword)
      @plus = @plus.supplier_id_is(params[:supplier_id]) if params[:supplier_id]
      @plus = @plus.all(:limit => 10)
    end
    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end

  private
  def assign_tab
    @tab = 'administrations'
    @current = 'plu'
  end

  def prepare_autocomplete
    @items = current_company.items
    #@suppliers = current_company.suppliers
  end
end
