class AddBuildsCountToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :builds_count, :string, default: 0, nil: false
  end
end
