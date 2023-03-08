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

ActiveRecord::Schema[7.0].define(version: 2023_03_07_222005) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer "agency", null: false
    t.bigint "number", null: false
    t.decimal "balance", precision: 16, scale: 2, null: false
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id", null: false
    t.index ["client_id"], name: "account_client_fk"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "last_name", null: false
    t.string "cpf", limit: 11, null: false
    t.date "date_of_birth", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "extracts", force: :cascade do |t|
    t.string "operation_type", null: false
    t.decimal "value", precision: 16, scale: 2, null: false
    t.date "date", null: false
    t.string "depositing_name"
    t.string "depositing_cpf", limit: 11
    t.integer "transfer_agency"
    t.bigint "transfer_account"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "extract_account_fk"
  end

  add_foreign_key "accounts", "clients"
  add_foreign_key "extracts", "accounts"
end
