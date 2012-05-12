# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120512082828) do

  create_table "builds", :force => true do |t|
    t.integer  "repository_id"
    t.string   "last_commit_id"
    t.string   "last_commit_message"
    t.integer  "position"
    t.integer  "duration"
    t.datetime "finished_at"
    t.string   "branch"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "aasm_state"
  end

  add_index "builds", ["repository_id"], :name => "index_builds_on_repository_id"

  create_table "repositories", :force => true do |t|
    t.integer  "github_id"
    t.string   "github_name"
    t.string   "name"
    t.string   "description"
    t.string   "git_url"
    t.boolean  "private"
    t.boolean  "fork"
    t.datetime "pushed_at"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.datetime "last_build_at"
    t.string   "html_url"
    t.string   "ssh_url"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "github_uid"
    t.string   "nickname"
    t.string   "name"
    t.string   "github_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
