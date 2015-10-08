class ChangeDataTypeForSpeakerIdInDiscussions < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute "ALTER TABLE discussions ALTER COLUMN speaker_id TYPE integer USING (speaker_id::integer);"
      end
      dir.down do
        change_column :discussions, :speaker_id, :string
      end
    end
  end
end
