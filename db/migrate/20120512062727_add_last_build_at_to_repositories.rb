# frozen_string_literal: true

class AddLastBuildAtToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :last_build_at, :datetime
  end
end
