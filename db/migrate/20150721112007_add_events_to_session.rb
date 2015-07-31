class AddEventsToSession < ActiveRecord::Migration
  def change
    change_table :sessions do |t|
      t.belongs_to :event
    end
  end
end
