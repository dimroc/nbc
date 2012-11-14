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

ActiveRecord::Schema.define(:version => 20121114023617) do

  create_table "blocks", :force => true do |t|
    t.integer  "region_id"
    t.integer  "left"
    t.integer  "bottom"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.spatial  "point",      :limit => {:srid=>3785, :type=>"point"}
  end

  add_index "blocks", ["point"], :name => "index_blocks_on_point", :spatial => true

  create_table "neighborhood_regions", :force => true do |t|
    t.integer "region_id"
    t.integer "neighborhood_id"
  end

  create_table "neighborhoods", :force => true do |t|
    t.string   "name",                                                :null => false
    t.string   "borough",                                             :null => false
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.spatial  "point",      :limit => {:srid=>3785, :type=>"point"}
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.string   "slug"
    t.spatial  "geometry",   :limit => {:srid=>3785, :type=>"geometry"}
    t.integer  "world_id"
    t.integer  "left",                                                   :default => 0, :null => false
    t.integer  "bottom",                                                 :default => 0, :null => false
  end

  add_index "regions", ["geometry"], :name => "index_regions_on_geometry", :spatial => true
  add_index "regions", ["slug"], :name => "index_regions_on_slug", :unique => true

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

  create_table "worlds", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "zip_code_maps", :force => true do |t|
    t.string   "zip"
    t.string   "po_name"
    t.string   "county"
    t.float    "shape_length"
    t.float    "shape_area"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.spatial  "point",        :limit => {:srid=>3785, :type=>"point"}
    t.spatial  "geometry",     :limit => {:srid=>3785, :type=>"geometry"}
  end

  add_index "zip_code_maps", ["zip"], :name => "index_zip_code_maps_on_zip"

end
