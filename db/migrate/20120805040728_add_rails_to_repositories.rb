# frozen_string_literal: true

class AddRailsToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :rails, :boolean, default: true, null: false
  end
end
