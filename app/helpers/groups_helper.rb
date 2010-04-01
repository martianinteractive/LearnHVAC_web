module GroupsHelper
  
  def scenarios
    @group.new_record? ? current_user.scenarios : @group.scenarios
  end
  
end
