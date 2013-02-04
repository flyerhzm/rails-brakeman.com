class SetRailsAsTrueToRepositories < ActiveRecord::Migration
  def up
    change_column :repositories, :rails, :boolean, default: true, null: false
  end

  def down
    change_column :repositories, :rails, :boolean, default: false, null: false
  end
end
