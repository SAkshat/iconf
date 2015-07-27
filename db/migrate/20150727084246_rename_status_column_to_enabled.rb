class RenameStatusColumnToEnabled < ActiveRecord::Migration
  def change
    rename_column :events, :status, :enabled
    rename_column :discussions, :status, :enabled
  end
end
