class Admins::CollegesController < Admins::ApplicationController
  
  def index
    @colleges = College.paginate :page => params[:page], :per_page => 50, :order => "value ASC"
  end
  
  def search
    @colleges = College.where("value LIKE '%#{params[:q]}%'").paginate(:page => params[:page], :per_page => 50)
    render :action => :index
  end

  def new
    @college = College.new
  end

  def show
    @college = College.find(params[:id])
  end

  def edit
    @college = College.find(params[:id])
  end

  def create
    @college = College.new(params[:college])
    
    if @college.save
      redirect_to(admins_college_path(@college), :notice => 'College was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @college = College.find(params[:id])
    
    if @college.update_attributes(params[:college])
      redirect_to(admins_college_path(@college), :notice => 'College was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @college = College.find(params[:id])
    
    @college.destroy
    redirect_to(admins_colleges_url, :notice => "College was successfully deleted.")
  end

end
