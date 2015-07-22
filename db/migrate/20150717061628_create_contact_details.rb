class CreateContactDetails < ActiveRecord::Migration
  def change
    create_table :contact_details do |t|
      t.integer :phone_number
      t.string :email
      t.references :contactable, polymorphic: true
    end
  end
end
