class CreateJoinTable < ActiveRecord::Migration
  def change
    create_table :discussions_users do |t|
      t.belongs_to :user
      t.belongs_to :discussion

      t.timestamps null: false
    end
  end
end
