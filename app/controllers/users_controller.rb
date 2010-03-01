class UsersController < ApplicationController

  before_filter :login_required
  
  # GET /users/new
  # GET /users/new.xml

  # render new.rhtml
  def new
    @userRoles = getRoles current_user.role.name
  end

  
  def create
    
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    
    @user = User.new(params[:user])
    @userRoles = getRoles current_user.role.name
    
    #always create user in same institution unless superadmin...
    if current_user.role.name != "superadmin"
      @user.institution = current_user.institution
    end  
    
    if @user.role.name=="superadmin" && current_user.role.name!="superadmin"
      flash[:warning] = "Can't create a superadmin."
      redirect_to :action=> 'new' and return
    end
    
    if current_user.role.name=="instructor" && (@user.role.name=="administrator" || @user.role.name=="superadmin")
      flash[:warning] = "Instructors can only create instructor or student users."
      redirect_to :action=> 'new' and return
    end
    
    if current_user.institution != @user.institution && current_user.role.name != "superadmin"
      flash[:warning] = "Can only create users within your own institution."
      redirect_to :action=> 'new' and return
    end
    
    respond_to do |format|
      if @user.save 
        format.html { redirect_to(users_url) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end 
    end
    
  rescue ActiveRecord::RecordInvalid
    respond_to do |format|
      format.html { render :action => 'new'}
      format.xml do
        unless @user.errors.empty?
          render :xml => @user.errors.to_xml_full
        else
          render :text => "error"
        end
      end
    end
  end
  
   
  def index
    
		@userRoles = Role.find(:all, :order=>"id")
    if current_user.role.name != "superadmin"	  
      @users = User.find(:all, :order=>'last_name', :conditions=> {:institution_id=>current_user.institution.id} )
    else
      @users = User.find(:all, :order=>'institution_id, last_name')
    end
   
    respond_to do |format|
      format.html
      format.xml {render :xml => @users}
    end 
    
  end


  def show
    @user = User.find(params[:id])
		@userRoles = Role.find(:all, :order=>"id")
		
		respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
		
  end


  
  def change_password

    @user = User.find(params[:id])
   
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def update_password
      
      @user=User.find(params[:id])
      
      if current_user.role.name != "superadmin"
      
        if current_user.institution != @user.institution 
          flash[:warning] = "You can only change the password of users within your own institution."
          redirect_to :action=> 'index' and return
        end
    
        if @user.role.name == "superadmin" 
          flash[:warning] = "You cannot change this user's password."
          redirect_to :action=> 'index' and return
        end
    
        if current_user != @user && @user.role.name=="administrator"
          flash[:warning] = "You cannot change an administrator's password."
          redirect_to :action=> 'index' and return
        end
      
        if current_user.role.name == "instructor" and ( @user.role.name != "student" && @user.role.name != "guest")
          flash[:notice] = "Instructors can only change passwords on students and guests"
          redirect_to :action=> 'index' and return
        end
      
      end
      
      if current_user.institution != @user.institution && current_user.role.name!="superadmin"
        flash[:warning] = "Can only modify users within your own institution."
        redirect_to :action=> 'index' and return
      end
      
      @user.update_attributes(:password=>params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
      if @user.save
          flash[:notice]="Password Changed"
          redirect_to :action=> 'index' and return
      end
      
      respond_to do |format|
        if  @user.update_attributes(:password=>params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
          flash[:notice] = 'Password changed.'
          format.html { redirect_to(@user) }
          format.xml  { head :ok }
        else
          format.html { render :action => "change_password" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
      end
    
    end
    
    
    
    

  def edit

    @user = User.find(params[:id])
           
		# @userRoles is an array that controls what roles are shown in the Roles pulldown
    # Roles are shown based on the user's own Role (e.g. permissions)
	
	  @userRoles = getRoles current_user.role.name
  		
  end



  def update
    
    @user = User.find(params[:id])
	  @userRoles = getRoles current_user.role.name
    
    #no messing with users from different institution unless you're a superadmin
    if current_user.institution != @user.institution && current_user.role.name != "superadmin"
      flash[:warning] = "Can only modify users within your own institution."
      redirect_to :action=> 'list' and return
    end
    
    #don't touch the superadmin if you're not one
    if current_user.role.name!="superadmin" && @user.role.name=="superadmin"
      flash[:warning] = "Can't update a superadmin user."
      redirect_to :action=> 'list' and return
    end
    
    #try to prevent administrator from demoting themselves
    if (@user.id == current_user.id) and (current_user.role.name=="administrator") and (params[:user][:role_id] != Role.find_by_name("administrator"))
      flash[:warning] = "Sorry! You can't demote yourself from administrator. You must have another administrator do this. Why give up power anyways?"
      redirect_to :action=> 'list' and return
    end
    
    #instructors can only modify students & guests
    if current_user.role.name=="instructor" && (@user.role.name=="instructor" || @user.role.name=="administrator" || @user.role.name=="superadmin")
      flash[:warning] = "Instructors can only modify other students or guests."
      redirect_to :action=> 'list' and return  
    end
  
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
    
    
  rescue ActiveRecord::StaleObjectError
      flash.now[:notice] = 'Conflict Error'
      render :action => 'conflict'  
  end
  

  
  # DELETE /users/1
  # DELETE /users/1.xml

  def destroy
    #it's ok for admins to destroy other admins
    
    @user = User.find(params[:id])
    
    #no deleting the super admin!
    if @user.role.name=="superadmin" 
      flash[:warning] = "You cannot destroy the superadmin."
      redirect_to :action=> 'list' and return
    end
    
    if current_user.institution != @user.institution && current_user.role.name != "superadmin"
      flash[:warning] = "Can only destroy users within your own institution."
      redirect_to :action=> 'list' and return
    end    
        
    if (current_user.role.name=="instructor" && (@user.role.name == "administrator" or @user.role.name=="superadministrator"))
      flash[:warning] = "You cannot destroy a " + @user.role.name  + " user"
      redirect_to :action=> 'list' and return
    end
    
    #try to prevent administrator from destroying themselves
    if (@user.id == current_user.id) 
      flash[:warning] = "Sorry! You can't destroy yourself. You must have another administrator do this."
      redirect_to :action=> 'list' and return
    end
        
    flash[:notice] = 'User was successfully destroyed.'
    @user.destroy
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
    
  end
  
  private
  
  
  def getRoles (roleName)
       
    userRoles = []
       
    case roleName
      
      when "superadmin"
        userRoles << Role.find_by_name("superadmin")
        userRoles << Role.find_by_name("administrator")
        userRoles << Role.find_by_name("instructor")
        userRoles << Role.find_by_name("student")
        userRoles << Role.find_by_name("guest")
    
      when "administrator"
        userRoles << Role.find_by_name("administrator")
        userRoles << Role.find_by_name("instructor")
        userRoles << Role.find_by_name("student")
        userRoles << Role.find_by_name("guest")
    
      when "instructor"
        userRoles << Role.find_by_name("student")
        userRoles << Role.find_by_name("guest")
    
    end
    
    userRoles
    
  end
  
  
  
end




