class RenameDesignationColumnToTitle < ActiveRecord::Migration
  def change
    rename_column :users, :designation, :title
  end
end
