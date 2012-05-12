class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.references :repository
      t.string :last_commit_id
      t.string :last_commit_message
      t.integer :position
      t.integer :duration
      t.datetime :finished_at
      t.string :branch

      t.timestamps
    end
    add_index :builds, :repository_id
  end
end
