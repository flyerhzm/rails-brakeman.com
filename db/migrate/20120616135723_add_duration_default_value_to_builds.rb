class AddDurationDefaultValueToBuilds < ActiveRecord::Migration
  def change
    change_column :builds, :duration, :integer, default: 0, nil: false
  end
end
