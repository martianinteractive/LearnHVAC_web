class Admins::Settings::EducationalEntitiesController < Admins::Settings::BaseController
  add_crumb("Educational Entities") { |instance| instance.send :admins_settings_educational_entities_path }
  
  def index
    @colleges = College.paginate :page => params[:page], :per_page => 50, :order => "value ASC"
  end
  
  def search
    @colleges = College.search(params[:q]).paginate(:page => params[:page], :per_page => 50)
    render :action => :index
  end

  def new
    @college = College.new
    add_crumb "New Entity", new_admins_settings_educational_entity_path
  end

  def show
    @college = College.find(params[:id])
    add_crumb @college.value, admins_settings_educational_entity_path(@college)
  end

  def edit
    @college = College.find(params[:id])
    add_crumb "Editing #{@college.value}", edit_admins_settings_educational_entity_path(@college)
  end

  def create
    @college = College.new(params[:college])
    
    if @college.save
      redirect_to(admins_settings_educational_entity_path(@college), :notice => 'College was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @college = College.find(params[:id])
    
    if @college.update_attributes(params[:college])
      redirect_to(admins_settings_educational_entity_path(@college), :notice => 'College was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @college = College.find(params[:id])    
    @college.destroy
    redirect_to(admins_settings_educational_entities_path, :notice => "College was successfully deleted.")
  end

end
