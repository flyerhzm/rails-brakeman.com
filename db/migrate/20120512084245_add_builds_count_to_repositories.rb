class AddBuildsCountToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :builds_count, :integer, default: 0, nil: false
  end
end
