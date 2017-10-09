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

ActiveRecord::Schema.define(version: 20170806094664) do

  create_table "cities", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", limit: 128
    t.string "alternative_names", limit: 256
    t.string "iso_code", limit: 128
    t.integer "country_id"
    t.integer "region_id"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.integer "population"
    t.integer "priority", default: 1000
    t.boolean "show_in_api", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_cities_on_country_id"
    t.index ["iso_code"], name: "index_cities_on_iso_code"
    t.index ["region_id"], name: "index_cities_on_region_id"
  end

  create_table "classifieds", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title", null: false
    t.text "description"
    t.boolean "featured", default: false
    t.string "status", limit: 16, default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_classifieds_on_status"
  end

  create_table "countries", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", limit: 128
    t.string "official_name", limit: 128
    t.string "iso_name", limit: 128
    t.string "fips", limit: 56
    t.string "iso_alpha_2", limit: 5
    t.string "iso_alpha_3", limit: 5
    t.string "itu_code", limit: 5
    t.string "dialing_prefix", limit: 56
    t.string "tld", limit: 16
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "capital", limit: 64
    t.string "continent", limit: 64
    t.string "currency_code", limit: 16
    t.string "currency_name", limit: 64
    t.string "is_independent", limit: 56
    t.string "languages", limit: 256
    t.integer "priority", default: 1000
    t.boolean "show_in_api", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fips"], name: "index_countries_on_fips"
    t.index ["iso_alpha_2"], name: "index_countries_on_iso_alpha_2"
    t.index ["iso_alpha_3"], name: "index_countries_on_iso_alpha_3"
  end

  create_table "documents", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "document"
    t.string "document_type"
    t.integer "documentable_id"
    t.string "documentable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_type"], name: "index_documents_on_document_type"
    t.index ["documentable_id", "documentable_type"], name: "index_documents_on_documentable_id_and_documentable_type"
  end

  create_table "events", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title", null: false
    t.string "venue", null: false
    t.text "description"
    t.date "date"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean "featured", default: false
    t.string "status", limit: 16, default: "unpublished", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_events_on_status"
  end

  create_table "images", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "image"
    t.string "image_type"
    t.integer "imageable_id"
    t.string "imageable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["image_type"], name: "index_images_on_image_type"
    t.index ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type"
  end

  create_table "import_data", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "importable_id"
    t.string "importable_type"
    t.string "data_type"
    t.string "status", limit: 16, default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["data_type"], name: "index_import_data_on_data_type"
    t.index ["importable_id", "importable_type"], name: "index_import_data_on_importable_id_and_importable_type"
    t.index ["status"], name: "index_import_data_on_status"
  end

  create_table "regions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", limit: 128
    t.string "iso_code", limit: 128
    t.integer "country_id"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.integer "priority", default: 1000
    t.boolean "show_in_api", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_regions_on_country_id"
    t.index ["iso_code"], name: "index_regions_on_iso_code"
  end

end
