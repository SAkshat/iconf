class AddEnabledColumnToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :enabled, null: false, default: true
    end
  end
end
