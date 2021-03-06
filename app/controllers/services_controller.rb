class ServicesController < ApplicationController
  before_filter :set_tab
  before_filter :authenticate

  def index
    @search = current_company.items.services.search(params[:search])
    @services = @search.paginate(:page => params[:page])
  end
  
  def show
    @service = current_company.items.services.find(params[:id])
  end

  def new
    @service = current_company.items.services.new
    @categories = current_company.categories.services.sorted
  end
  
  def create
    @service = current_company.items.services.new(params[:item])
    if @service.save
      flash[:notice] = "Service created successfuly"
      redirect_to service_path(@service)
    else
      @categories = current_company.categories.services.sorted
      render :action => 'new'
    end
  end

  def edit
    @service = current_company.items.find(params[:id])
  end

  def update
    @service = current_company.items.services.find(params[:id])
    if @service.update_attributes(params[:item])
      flash[:success] = "Servive updated successfully"
      redirect_to service_path(@service)
    else
      @categories = current_company.categories.services.sorted
      render :action => 'edit'
    end
  end

  def destroy
    @service = current_company.items.services.find(params[:id])
    if @service
      @service.delete
      flash[:notice] = "Service deleted"
    else
      flash[:error] = "Service not found"
    end
    redirect_to services_path
  end

  private
  def set_tab
    @tab = 'administrations'
    @current = 'svc'
  end
end
