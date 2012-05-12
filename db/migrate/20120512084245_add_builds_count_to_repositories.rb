class AddBuildsCountToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :builds_count, :string
  end
end
