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

ActiveRecord::Schema.define(version: 20170322144922) do

  create_table "documents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "document"
    t.string   "document_type"
    t.integer  "documentable_id"
    t.string   "documentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["documentable_id", "documentable_type"], name: "index_documents_on_documentable_id_and_documentable_type", using: :btree
  end

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title",       limit: 512,                           null: false
    t.string   "venue",       limit: 256,                           null: false
    t.text     "description", limit: 65535
    t.date     "date"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "featured",                  default: false
    t.string   "status",      limit: 16,    default: "unpublished", null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.index ["status"], name: "index_events_on_status", using: :btree
  end

  create_table "images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "image"
    t.string   "image_type"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type", using: :btree
  end

  create_table "import_data", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "importable_id"
    t.string   "importable_type"
    t.string   "data_type"
    t.string   "status",          limit: 16, default: "pending", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["data_type"], name: "index_import_data_on_data_type", using: :btree
    t.index ["importable_id", "importable_type"], name: "index_import_data_on_importable_id_and_importable_type", using: :btree
    t.index ["status"], name: "index_import_data_on_status", using: :btree
  end

end
