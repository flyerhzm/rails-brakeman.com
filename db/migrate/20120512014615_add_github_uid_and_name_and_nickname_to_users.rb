# frozen_string_literal: true

class AddGithubUidAndNameAndNicknameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :github_uid, :string
    add_column :users, :nickname, :string
    add_column :users, :name, :string
  end
end
