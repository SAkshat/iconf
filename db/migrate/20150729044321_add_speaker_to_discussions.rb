class AddSpeakerToDiscussions < ActiveRecord::Migration
  def change
    add_column :discussions, :speaker_id, :string
    add_index :discussions, :speaker_id
  end
end
