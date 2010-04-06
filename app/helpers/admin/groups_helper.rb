module Admin::GroupsHelper
  def scenarios_ids
    @group.new_record? ? [] : @group.scenarios_ids
  end
end
