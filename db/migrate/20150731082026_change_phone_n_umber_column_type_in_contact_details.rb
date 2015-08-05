class ChangePhoneNUmberColumnTypeInContactDetails < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up { change_column :contact_details, :phone_number, :string }
      dir.down { change_column :contact_details, :phone_number, :integer }
    end
  end
end
