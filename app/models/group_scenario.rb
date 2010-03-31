class GroupScenario < ActiveRecord::Base
  include BelongsToDocument
  belongs_to :group
  belongs_to_document :scenario
end
