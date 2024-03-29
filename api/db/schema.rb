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

ActiveRecord::Schema.define(version: 20140831114628) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounting_entries", force: true do |t|
    t.integer  "bank_entry_id"
    t.date     "date"
    t.integer  "amount_cents",  default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
  end

  create_table "bank_entries", force: true do |t|
    t.integer  "amount_cents"
    t.date     "date"
    t.string   "reference"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.boolean  "is_test",        default: false
    t.date     "is_active_from"
    t.date     "is_active_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
