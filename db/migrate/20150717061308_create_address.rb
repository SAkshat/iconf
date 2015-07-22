class CreateAddress < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.string :country
      t.string :zipcode
    end
  end
end
