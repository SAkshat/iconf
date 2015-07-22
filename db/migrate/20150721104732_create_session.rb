class CreateSession < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :name
      t.string :topic
      t.date :date
      t.time :start_time
      t.time :end_time
      t.string :location
      t.string :description
      t.boolean :status, null: false, default: true
    end
  end
end
