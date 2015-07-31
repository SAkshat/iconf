class AddCreatorIdColumnToDiscussions < ActiveRecord::Migration
  def change
    add_column :discussions, :creator_id, :integer
    add_index :discussions, :creator_id
  end
end
