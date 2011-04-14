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

ActiveRecord::Schema.define(:version => 20110414164922) do

  create_table "class_notification_emails", :force => true do |t|
    t.integer  "class_id"
    t.string   "recipients"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "class_notification_emails", ["class_id"], :name => "index_class_notification_emails_on_class_id"

  create_table "client_versions", :force => true do |t|
    t.string   "version"
    t.string   "url"
    t.date     "release_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "colleges", :force => true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "colleges", ["value"], :name => "index_colleges_on_value"

  create_table "group_scenarios", :force => true do |t|
    t.integer  "group_id"
    t.integer  "scenario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["creator_id"], :name => "index_groups_on_instructor_id"

  create_table "institutions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_code"
  end

  add_index "institutions", ["name"], :name => "index_institutions_on_name"

  create_table "master_scenarios", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "desktop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.time     "deleted_at"
  end

  add_index "master_scenarios", ["desktop_id"], :name => "index_master_scenarios_on_desktop_id"
  add_index "master_scenarios", ["user_id"], :name => "index_master_scenarios_on_user_id"

  create_table "memberships", :force => true do |t|
    t.integer  "member_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "member_role"
    t.integer  "scenario_id"
  end

  add_index "memberships", ["group_id"], :name => "index_memberships_on_group_id"
  add_index "memberships", ["member_id", "group_id", "type"], :name => "index_memberships_on_member_id_and_group_id_and_type"
  add_index "memberships", ["member_id"], :name => "index_memberships_on_student_id"
  add_index "memberships", ["scenario_id"], :name => "index_memberships_on_scenario_id"
  add_index "memberships", ["type"], :name => "index_memberships_on_type"

  create_table "regions", :force => true do |t|
    t.string "value"
    t.string "country"
  end

  add_index "regions", ["country"], :name => "index_regions_on_country"

  create_table "scenarios", :force => true do |t|
    t.string   "name"
    t.string   "short_description"
    t.text     "description"
    t.string   "goal"
    t.date     "longterm_start_date",            :default => '2010-01-01'
    t.date     "longterm_stop_date",             :default => '2010-07-31'
    t.datetime "realtime_start_datetime",        :default => '2010-01-15 00:00:00'
    t.integer  "level",                          :default => 1
    t.boolean  "public",                         :default => false
    t.boolean  "inputs_visible",                 :default => true
    t.boolean  "inputs_enabled",                 :default => true
    t.boolean  "faults_visible",                 :default => true
    t.boolean  "faults_enabled",                 :default => true
    t.boolean  "valve_info_enabled",             :default => true
    t.boolean  "allow_longterm_date_change",     :default => false
    t.boolean  "allow_realtime_datetime_change", :default => false
    t.boolean  "student_debug_access",           :default => false
    t.integer  "desktop_id"
    t.integer  "master_scenario_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sample",                         :default => false
  end

  add_index "scenarios", ["desktop_id"], :name => "index_scenarios_on_desktop_id"
  add_index "scenarios", ["master_scenario_id"], :name => "index_scenarios_on_master_scenario_id"
  add_index "scenarios", ["user_id"], :name => "index_scenarios_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

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
    t.string   "perishable_token",  :default => "",                           :null => false
    t.boolean  "enabled",           :default => true
    t.string   "city"
    t.string   "state"
    t.string   "country",           :default => "United States"
    t.string   "phone"
    t.string   "time_zone",         :default => "Pacific Time (US & Canada)"
    t.boolean  "list_directory",    :default => false
  end

  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["role_code"], :name => "index_users_on_role_code"

  create_table "variables", :force => true do |t|
    t.string   "name"
    t.string   "display_name"
    t.text     "description"
    t.string   "unit_si"
    t.string   "unit_ip"
    t.string   "si_to_ip"
    t.string   "left_label"
    t.string   "right_label"
    t.string   "subsection"
    t.string   "zone_position"
    t.string   "fault_widget_type"
    t.text     "notes"
    t.string   "component_code"
    t.string   "io_type"
    t.string   "view_type",         :default => "public"
    t.integer  "index"
    t.integer  "lock_version",      :default => 0
    t.integer  "node_sequence",     :default => 0
    t.float    "low_value",         :default => 0.0
    t.float    "high_value",        :default => 0.0
    t.float    "initial_value",     :default => 0.0
    t.boolean  "is_fault",          :default => false
    t.boolean  "is_percentage",     :default => false
    t.boolean  "disabled",          :default => false
    t.boolean  "fault_is_active",   :default => false
    t.string   "type"
    t.integer  "scenario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "variables", ["component_code"], :name => "index_variables_on_component_code"
  add_index "variables", ["high_value"], :name => "index_variables_on_high_value"
  add_index "variables", ["initial_value"], :name => "index_variables_on_initial_value"
  add_index "variables", ["io_type"], :name => "index_variables_on_io_type"
  add_index "variables", ["low_value"], :name => "index_variables_on_low_value"
  add_index "variables", ["name"], :name => "index_variables_on_name"
  add_index "variables", ["scenario_id"], :name => "index_variables_on_scenario_id"
  add_index "variables", ["type"], :name => "index_variables_on_type"

end
