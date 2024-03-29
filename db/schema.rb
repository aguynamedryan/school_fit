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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120615064104) do

  create_table "recommendations", :force => true do |t|
    t.string   "grade"
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "cdscode"
    t.string   "district"
    t.string   "county"
  end

  add_index "schools", ["cdscode"], :name => "index_schools_on_cdscode"
  add_index "schools", ["district"], :name => "index_schools_on_district"

  create_table "scores", :force => true do |t|
    t.integer  "school_id"
    t.integer  "year"
    t.float    "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "scores", ["school_id", "year"], :name => "index_scores_on_school_id_and_year"
  add_index "scores", ["school_id"], :name => "index_scores_on_school_id"

end
