class RenameSessionsToDiscussions < ActiveRecord::Migration
  def change
    rename_table :sessions, :discussions
  end
end
