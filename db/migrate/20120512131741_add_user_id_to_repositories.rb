# frozen_string_literal: true

class AddUserIdToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :user_id, :integer
  end
end
