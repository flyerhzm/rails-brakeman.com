class RenameGithubUrlToGitUrl < ActiveRecord::Migration
  def up
    rename_column :repositories, :github_url, :git_url
  end

  def down
    rename_column :repositories, :git_url, :github_url
  end
end
