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

ActiveRecord::Schema.define(version: 2019_02_24_153055) do

  create_table "profiles", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.string "first_name"
    t.string "last_name"
    t.integer "phone_number"
    t.float "rating"
    t.float "balance"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_profiles_on_email", unique: true
    t.index ["reset_password_token"], name: "index_profiles_on_reset_password_token", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.float "rating"
    t.string "comment"
    t.integer "profile_id"
    t.index ["profile_id"], name: "index_reviews_on_profile_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.float "amount"
    t.datetime "made_at"
    t.integer "currency", default: 0
    t.integer "payer_id"
    t.integer "payee_id"
    t.index ["payer_id"], name: "index_transactions_on_payer_id"
  end

end
