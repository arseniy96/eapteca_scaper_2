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

ActiveRecord::Schema.define(version: 2020_07_15_162016) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drugs", force: :cascade do |t|
    t.string "name"
    t.string "barcode"
    t.string "vendor_code"
    t.string "description_file"
    t.string "substance"
    t.string "form"
    t.integer "num"
    t.string "vendor"
    t.string "composition"
    t.string "shelf_life"
    t.string "brand"
    t.boolean "prescription"
    t.string "pharm_effect"
    t.string "indications"
    t.string "contraindications"
    t.string "side_effects"
    t.string "interaction"
    t.string "cours"
    t.string "overdose"
    t.string "special_instruction"
    t.string "release_form"
    t.string "storage"
    t.string "pregnancy"
    t.string "image_file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
