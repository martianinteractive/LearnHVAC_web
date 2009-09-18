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

ActiveRecord::Schema.define(:version => 20090124173054) do

  create_table "actions", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "action_id"
    t.integer  "value_id"
    t.string   "value_string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_configs", :force => true do |t|
    t.string   "authentication_source"
    t.datetime "updated_at"
  end

  create_table "components", :force => true do |t|
    t.string   "component_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "institutions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "institutions_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lhlog", :force => true do |t|
    t.integer  "user_id"
    t.integer  "action_id"
    t.integer  "value_id"
    t.string   "value_string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lhlog", ["user_id"], :name => "index_hits_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scenario_systemvariables", :force => true do |t|
    t.integer "scenario_id"
    t.integer "systemvariable_id"
    t.integer "institution_id"
    t.string  "applicationID",     :default => "PUBLIC"
    t.boolean "disabled",          :default => false
    t.float   "low_value",         :default => 0.0
    t.float   "initial_value",     :default => 0.0
    t.float   "high_value",        :default => 0.0
  end

  create_table "scenarios", :force => true do |t|
    t.string   "scenID"
    t.integer  "institution_id"
    t.integer  "weatherfile_id"
    t.string   "name"
    t.string   "short_description"
    t.text     "description"
    t.text     "goal"
    t.string   "movie_URL"
    t.string   "thumbnail_URL"
    t.integer  "level",                          :default => 1
    t.boolean  "inputs_visible",                 :default => true
    t.boolean  "inputs_enabled",                 :default => true
    t.boolean  "faults_visible",                 :default => true
    t.boolean  "faults_enabled",                 :default => true
    t.boolean  "drag_sensor_enabled",            :default => true
    t.boolean  "valve_info_enabled",             :default => true
    t.boolean  "use_custom_output_graphs",       :default => false
    t.integer  "position"
    t.integer  "lock_version",                   :default => 0
    t.datetime "longterm_start_date",            :default => '2009-01-01 00:00:00'
    t.datetime "longterm_stop_date",             :default => '2009-12-31 00:00:00'
    t.boolean  "allow_longterm_date_change",     :default => false
    t.datetime "realtime_start_datetime",        :default => '2009-01-01 00:00:00'
    t.boolean  "allow_realtime_datetime_change", :default => false
    t.boolean  "force_long_term_sim",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "systemvariables", :force => true do |t|
    t.string   "name"
    t.integer  "institution_id"
    t.string   "display_name"
    t.integer  "component_id"
    t.string   "description"
    t.string   "typeID"
    t.float    "min_value",         :default => 0.0
    t.float    "default_value",     :default => 0.0
    t.float    "max_value",         :default => 0.0
    t.string   "unit_si"
    t.string   "unit_ip"
    t.string   "si_to_ip"
    t.boolean  "is_fault",          :default => false
    t.boolean  "global_disable",    :default => false
    t.string   "left_label"
    t.string   "right_label"
    t.string   "subsection"
    t.string   "zone_position"
    t.boolean  "is_percentage",     :default => false
    t.string   "fault_widget_type"
    t.text     "notes"
    t.integer  "lock_version",      :default => 0
    t.integer  "node_sequence",     :default => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "hashed_password"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.integer  "institution_id"
    t.integer  "role_id"
    t.string   "student_id"
    t.datetime "lastlogin"
    t.string   "salt"
    t.integer  "lock_version",    :default => 0
    t.boolean  "active",          :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weatherfiles", :force => true do |t|
    t.string "name"
    t.text   "description"
  end

end
