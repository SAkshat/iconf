class AddNameDesignationToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :name
      t.string :designation
    end
  end
end
