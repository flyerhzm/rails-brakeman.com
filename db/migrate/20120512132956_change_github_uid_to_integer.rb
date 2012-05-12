class ChangeGithubUidToInteger < ActiveRecord::Migration
  def up
    change_column :users, :github_uid, :integer
  end

  def down
    change_column :users, :github_uid, :string
  end
end
