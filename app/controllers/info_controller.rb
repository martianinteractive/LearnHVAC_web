class InfoController < ApplicationController
  
  def getInfo
    msg  =  "Learn HVAC : time : " + Time.new.to_s + " : " + Scenario.count.to_s + " scenarios"
    render :text => msg
  end  
  
end
