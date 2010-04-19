# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100419224135) do

  create_table "client_versions", :force => true do |t|
    t.string   "version"
    t.string   "url"
    t.date     "release_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colleges", :force => true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "colleges", ["value"], :name => "index_colleges_on_value"

  create_table "group_scenarios", :force => true do |t|
    t.integer  "group_id"
    t.string   "scenario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "instructor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["instructor_id"], :name => "index_groups_on_instructor_id"

  create_table "institutions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_code"
  end

  add_index "institutions", ["name"], :name => "index_institutions_on_name"

  create_table "memberships", :force => true do |t|
    t.integer  "student_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["group_id"], :name => "index_memberships_on_group_id"
  add_index "memberships", ["student_id"], :name => "index_memberships_on_student_id"

  create_table "regions", :force => true do |t|
    t.string "value"
    t.string "country"
  end

  add_index "regions", ["country"], :name => "index_regions_on_country"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "institution_id"
    t.boolean  "active",            :default => true
    t.integer  "student_id"
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "last_request_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_code",         :default => 0
    t.string   "perishable_token",  :default => "",              :null => false
    t.boolean  "enabled",           :default => true
    t.string   "city"
    t.string   "state"
    t.string   "country",           :default => "United States"
  end

  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"

end
