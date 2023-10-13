# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_10_13_000118) do
  create_table "flights", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "golfers", primary_key: "player_id", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "world_ranking"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groupings", charset: "utf8mb3", force: :cascade do |t|
    t.string "flight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leaderboards", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "golfer_id"
    t.integer "year"
    t.integer "position"
    t.integer "round_one"
    t.integer "round_two"
    t.integer "round_three"
    t.integer "round_four"
    t.integer "total"
    t.integer "earnings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["golfer_id"], name: "index_leaderboards_on_golfer_id"
  end

  create_table "user_submissions", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "golfer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["golfer_id"], name: "index_user_submissions_on_golfer_id"
    t.index ["user_id"], name: "index_user_submissions_on_user_id"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "username"
    t.string "firstname"
    t.string "lastname"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
