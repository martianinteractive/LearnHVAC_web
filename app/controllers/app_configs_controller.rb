class AppConfigsController < ApplicationController
  
  before_filter :login_required, :only=>['index', 'hidden']
  
  
  def index
    render :action=>'edit'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def edit
    #@app_config = AppConfig.find(1)
    #@authentication_sources = ['LOCAL', 'MOODLE']
  end

  def update
    #@app_config = AppConfig.find(params[:id])
    #if @app_config.update_attributes(params[:app_config])
      #flash[:notice] = 'AppConfig was successfully updated.'
      #redirect_to :action => 'confirmed', :id => @app_config and return
    #else
      #flash[:warning] = 'AppConfig was not successfully updated. Please contact the administrator for help.'
      #render :action => 'edit'
    #end
  end

  def confirmed
    
  end
  
end
