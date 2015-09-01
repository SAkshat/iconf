class CreateRatingsTable < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer  :rating
      t.references :user
      t.integer :discussion_id
      t.timestamps null: false
    end
  end
end
