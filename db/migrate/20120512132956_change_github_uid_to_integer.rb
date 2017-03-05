class ChangeGithubUidToInteger < ActiveRecord::Migration
  def up
    change_column :users, :github_uid, 'integer USING CAST(github_uid AS integer)'
  end

  def down
    change_column :users, :github_uid, :string
  end
end
