class AddEventRefToAddress < ActiveRecord::Migration
  def change
    change_table :addresses do |t|
      t.belongs_to :event
    end
  end
end
