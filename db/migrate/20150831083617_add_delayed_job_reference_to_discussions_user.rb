class AddDelayedJobReferenceToDiscussionsUser < ActiveRecord::Migration
  def change
    change_table :discussions_users do |t|
      t.references :delayed_job
    end
  end
end
