# frozen_string_literal: true

class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.integer :github_id
      t.string :github_name
      t.string :name
      t.string :description
      t.string :github_url
      t.boolean :private
      t.boolean :fork
      t.datetime :pushed_at

      t.timestamps
    end
  end
end
