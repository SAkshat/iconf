class CreateEvent < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.string :description
      t.string :logo
      t.boolean :status, default: true, null: false

      t.timestamps null: false

    end
  end
end
