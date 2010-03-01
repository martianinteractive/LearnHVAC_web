
require 'weborb/context'
require 'rbconfig'
require 'md5'

class ScenarioService
	
  def getScenarioList
    APPLOG.info("#ScenarioService: getScenarioList() getting scenario list")
    scenarioList = Scenario.find(:all, :select=> "scenID, name, short_description, description, thumbnail_URL, level", :order=>"position")
  end
	
	
  def getScenario(scenID, login)
    
     APPLOG.info("#ScenarioService: getScenario() scenID: " + scenID.to_s + " login: " + login.to_s)
    
    #This function retrieves the complete XML description of a Scenario
    
    scenario = Scenario.find_by_scenID(scenID)
    
    if scenario
    
      xml = scenario.get_xml
	  
      #Log activity
      begin
	    u = User.find_by_login(login)
        if u
  	      activity = Activity.new
          activity.action = Action.find_by_name("LoadScenario")
          activity.user = User.find_by_login(login)
          activity.value_id = scenario.id
          activity.save()
        end
      rescue
        APPLOG.error("#ScenarioService: getScenario() Couldn't save activity. getScenario() function.")
      end
      
      #return complete xml structure for scenario
      return xml
	  
    else
      return nil
    end
		
  end
	
	
	  
end
