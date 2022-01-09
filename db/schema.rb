# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_01_09_132046) do

  create_table "runs", force: :cascade do |t|
    t.datetime "start_time"
    t.decimal "distance"
    t.integer "duration"
    t.integer "temperature"
    t.integer "elev_gain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_race"
    t.string "notes", limit: 255
    t.string "race_name", limit: 255
    t.integer "shoe_id"
    t.boolean "precip"
    t.boolean "is_night"
    t.integer "weather_type_id"
    t.integer "heart_rate"
    t.integer "humidity"
    t.decimal "intensity"
    t.index ["shoe_id"], name: "index_runs_on_shoe_id"
    t.index ["weather_type_id"], name: "index_runs_on_weather_type_id"
  end

  create_table "shoes", force: :cascade do |t|
    t.string "manufacturer", limit: 255
    t.string "model", limit: 255
    t.string "color_primary", limit: 255
    t.string "color_secondary", limit: 255
    t.decimal "size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "color_tertiary", limit: 255
  end

  create_table "weather_types", force: :cascade do |t|
    t.string "name", limit: 255
    t.boolean "is_precip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "day_icon"
    t.string "night_icon"
  end

end
