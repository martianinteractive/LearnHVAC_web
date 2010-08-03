module Instructors::GroupsHelper
  
  def scenarios
    @group.new_record? ? current_user.created_scenarios : @group.scenarios
  end
  
end
