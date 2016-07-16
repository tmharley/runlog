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

ActiveRecord::Schema.define(version: 20160716223146) do

  create_table "runs", force: true do |t|
    t.datetime "start_time"
    t.decimal  "distance"
    t.integer  "duration"
    t.integer  "temperature"
    t.integer  "elev_gain"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "is_race"
    t.string   "notes"
    t.string   "race_name"
    t.integer  "shoe_id"
    t.boolean  "precip"
    t.boolean  "is_night"
    t.integer  "weather_type_id"
  end

  add_index "runs", ["shoe_id"], name: "index_runs_on_shoe_id"
  add_index "runs", ["weather_type_id"], name: "index_runs_on_weather_type_id"

  create_table "shoes", force: true do |t|
    t.string   "manufacturer"
    t.string   "model"
    t.string   "color_primary"
    t.string   "color_secondary"
    t.decimal  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color_tertiary"
  end

  create_table "weather_types", force: true do |t|
    t.string   "name"
    t.boolean  "is_precip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
