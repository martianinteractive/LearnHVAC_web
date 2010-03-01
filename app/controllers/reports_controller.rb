
require 'ziya'

class ReportsController < ApplicationController

  include Ziya
  
  before_filter :login_required

  def total_downloads_chart_refresh
    
    #add the following to prevent problems in IE
    response.headers["Cache-Control"] = "cache,must-revalidate"
    response.headers["Pragma"] = "public"
    
    chart = Ziya::Charts::Bar.new()

    @actionID = Action.find_by_name("LoadScenario").id
    @scenarioNames = []
    @counts = []
    
    for @scenario in Scenario.find(:all)
      num_downloads = Activity.count(["action_id=? and value_id=?", @actionID, @scenario.id])
      @scenarioNames.push(@scenario.name)
      @counts.push(num_downloads)
    end
    
    chart.add(:axis_category_text, @scenarioNames)
    chart.add(:series, "Number of Scenario Downloads", @counts)
    render :xml => chart.to_xml
    
  end

  def logins_by_user_chart_refresh
    
    #add the following to prevent problems in IE
    response.headers["Cache-Control"] = "cache,must-revalidate"
    response.headers["Pragma"] = "public"
    
    chart = Ziya::Charts::Bar.new()

    @downloadActionID = Action.find_by_name("FlashClientLogin").id
    
    @userLogins = []
    @counts = []
    
    for @user in User.find(:all)                                        
      num_logins = Activity.count(:conditions => ['user_id=? and action_id=?', @user.id, @downloadActionID])
      @userLogins.push(@user.login)
      @counts.push(num_logins)
    end
    
    chart.add(:axis_category_text, @userLogins)
    chart.add(:series, "Number of User Logins", @counts)
    render :xml => chart.to_xml
    
  end

  def logins_log
    
    p current_user.role.name
    
    @downloadActionID = Action.find_by_name("FlashClientLogin").id
      
    if current_user.role.name == "superadmin"	  
      @activities = Activity.find(:all, :order=>'created_at DESC', :conditions=>['action_id=?', @downloadActionID])  
    else
      
      #There must be a simpler way to find activites from users in a certain institution than how I'm doing this...
      
      @users = User.find(:all,  :conditions=>['institution_id=?', current_user.institution_id])
    
      @activities = new Array()
    
      @users.each do |user|
        @actvs = Activity.find(:all, :order=>'created_at DESC', :conditions=>['action_id=?', @downloadActionID])
        @activites.push  = @actvs
      end
      
    end
   
    
    respond_to do |format|
      format.html
    end
    
  end

  
  
  def index
    
  end
  
  def total_downloads_chart
    
  end
  
  def logins_by_user_chart
  
  end
  
  
end
