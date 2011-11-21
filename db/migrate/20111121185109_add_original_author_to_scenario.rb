class AddOriginalAuthorToScenario < ActiveRecord::Migration
  def change
    add_column :scenarios, :original_author_id, :integer
  end
end
