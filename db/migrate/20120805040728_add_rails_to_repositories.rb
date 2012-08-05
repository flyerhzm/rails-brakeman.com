class AddRailsToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :rails, :boolean, default: false, null: false
  end
end
