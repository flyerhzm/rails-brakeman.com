class AddWarningsCountToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :warnings_count, :integer, default: 0, null: false
  end
end
