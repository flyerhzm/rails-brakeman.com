class AddVisibleToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :visible, :boolean, default: true, nil: false
  end
end
