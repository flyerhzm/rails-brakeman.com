class AddRailsToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :rails, :boolean, default: true, null: false
  end
end
