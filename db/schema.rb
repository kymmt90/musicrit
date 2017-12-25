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

ActiveRecord::Schema.define(version: 2017_12_25_130056) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "albums", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", default: ""
    t.date "released_on", null: false
    t.integer "musician_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["musician_id", "title", "released_on"], name: "index_albums_on_musician_id_and_title_and_released_on", unique: true
    t.index ["musician_id"], name: "index_albums_on_musician_id"
  end

  create_table "musicians", force: :cascade do |t|
    t.string "name", null: false
    t.string "begun_in", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "begun_in"], name: "index_musicians_on_name_and_begun_in"
  end

  create_table "releases", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", default: "", null: false
    t.date "released_on", null: false
    t.integer "musician_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["musician_id", "title", "released_on"], name: "index_releases_on_musician_id_and_title_and_released_on", unique: true
  end

  create_table "tracks", force: :cascade do |t|
    t.integer "release_id"
    t.string "title", null: false
    t.integer "disc_number", null: false
    t.integer "track_number", null: false
    t.text "description", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["release_id", "track_number"], name: "index_tracks_on_release_id_and_track_number", unique: true
  end

end
