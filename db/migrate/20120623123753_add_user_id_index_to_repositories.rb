class AddUserIdIndexToRepositories < ActiveRecord::Migration
  def change
    add_index :repositories, :user_id
  end
end
