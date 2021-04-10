# frozen_string_literal: true

class AddHtmlUrlAndSshUrlToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :html_url, :string
    add_column :repositories, :ssh_url, :string
  end
end
