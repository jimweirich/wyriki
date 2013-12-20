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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131220062847) do

  create_table "pages", force: true do |t|
    t.integer  "wiki_id"
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["wiki_id", "name"], name: "index_pages_on_wiki_id_and_name", unique: true
  add_index "pages", ["wiki_id"], name: "index_pages_on_wiki_id"

  create_table "permissions", force: true do |t|
    t.integer  "user_id"
    t.integer  "wiki_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["user_id"], name: "index_permissions_on_user_id"
  add_index "permissions", ["wiki_id"], name: "index_permissions_on_wiki_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

  create_table "wikis", force: true do |t|
    t.string   "name"
    t.string   "home_page"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wikis", ["name"], name: "index_wikis_on_name", unique: true

end
