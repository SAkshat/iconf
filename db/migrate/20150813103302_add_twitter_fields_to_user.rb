class AddTwitterFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :image_path, :string
    add_column :users, :nickname, :string
    add_column :users, :uid, :string
    add_column :users, :twitter_url, :string
  end
end
