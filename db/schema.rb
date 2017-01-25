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

ActiveRecord::Schema.define(version: 20170125112035) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointment_summaries", force: :cascade do |t|
    t.integer  "transactions",     default: 0,           null: false
    t.integer  "bookings",         default: 0,           null: false
    t.integer  "completions",      default: 0,           null: false
    t.string   "delivery_partner", default: "",          null: false
    t.string   "source",           default: "automatic", null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "year_month_id",    default: 0,           null: false
    t.index ["delivery_partner"], name: "index_appointment_summaries_on_delivery_partner", using: :btree
    t.index ["year_month_id"], name: "index_appointment_summaries_on_year_month_id", using: :btree
  end

  create_table "appointment_versions", force: :cascade do |t|
    t.string   "uid",              default: "",    null: false
    t.datetime "booked_at",                        null: false
    t.datetime "booking_at",                       null: false
    t.datetime "transaction_at",                   null: false
    t.boolean  "cancelled",        default: false
    t.string   "booking_status",   default: "",    null: false
    t.string   "delivery_partner", default: "",    null: false
    t.integer  "version",          default: 0,     null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "booking_ref",      default: "",    null: false
  end

  create_table "appointments", force: :cascade do |t|
    t.string   "uid",              default: "",    null: false
    t.datetime "booked_at",                        null: false
    t.datetime "booking_at",                       null: false
    t.datetime "transaction_at",                   null: false
    t.boolean  "cancelled",        default: false
    t.string   "booking_status",   default: "",    null: false
    t.string   "delivery_partner", default: "",    null: false
    t.integer  "version",          default: 0,     null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "booking_ref",      default: "",    null: false
    t.index ["booking_status"], name: "index_appointments_on_booking_status", using: :btree
    t.index ["delivery_partner"], name: "index_appointments_on_delivery_partner", using: :btree
    t.index ["version"], name: "index_appointments_on_version", using: :btree
  end

  create_table "blazer_audits", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "query_id"
    t.text     "statement"
    t.string   "data_source"
    t.datetime "created_at"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.integer  "creator_id"
    t.integer  "query_id"
    t.string   "state"
    t.string   "schedule"
    t.text     "emails"
    t.string   "check_type"
    t.text     "message"
    t.datetime "last_run_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.integer  "dashboard_id"
    t.integer  "query_id"
    t.integer  "position"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.integer  "creator_id"
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.integer  "creator_id"
    t.string   "name"
    t.text     "description"
    t.text     "statement"
    t.string   "data_source"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "code_lookups", force: :cascade do |t|
    t.string   "from"
    t.string   "to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from"], name: "index_code_lookups_on_from", unique: true, using: :btree
  end

  create_table "cost_items", force: :cascade do |t|
    t.string   "name",             default: "",    null: false
    t.boolean  "current",          default: true,  null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "web_cost",         default: false, null: false
    t.string   "delivery_partner", default: "",    null: false
    t.string   "cost_group",       default: "",    null: false
  end

  create_table "costs", force: :cascade do |t|
    t.integer  "cost_item_id"
    t.integer  "value_delta",   default: 0,     null: false
    t.integer  "user_id"
    t.boolean  "forecast",      default: false, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "year_month_id", default: 0,     null: false
    t.index ["cost_item_id"], name: "index_costs_on_cost_item_id", using: :btree
    t.index ["user_id"], name: "index_costs_on_user_id", using: :btree
    t.index ["year_month_id"], name: "index_costs_on_year_month_id", using: :btree
  end

  create_table "daily_call_volumes", force: :cascade do |t|
    t.string   "source"
    t.date     "date"
    t.integer  "call_volume"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "contact_centre", default: 0, null: false
    t.integer  "twilio",         default: 0, null: false
    t.index ["date"], name: "index_daily_call_volumes_on_date", unique: true, using: :btree
  end

  create_table "satisfactions", force: :cascade do |t|
    t.datetime "given_at",                      null: false
    t.string   "uid",              default: "", null: false
    t.string   "delivery_partner", default: "", null: false
    t.string   "satisfaction_raw", default: "", null: false
    t.integer  "satisfaction",                  null: false
    t.string   "location",         default: "", null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "tp_calls", force: :cascade do |t|
    t.string   "uid"
    t.datetime "called_at"
    t.string   "outcome"
    t.string   "third_party_referring"
    t.string   "pension_provider"
    t.integer  "call_duration"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "location",              default: ""
  end

  create_table "twilio_calls", force: :cascade do |t|
    t.string   "uid"
    t.datetime "called_at"
    t.string   "inbound_number"
    t.string   "outbound_number"
    t.integer  "call_duration"
    t.decimal  "cost",                                  precision: 10, scale: 5
    t.string   "outcome"
    t.string   "delivery_partner"
    t.string   "location_uid"
    t.string   "location"
    t.string   "location_postcode"
    t.string   "booking_location"
    t.string   "booking_location_postcode"
    t.datetime "created_at",                                                                  null: false
    t.datetime "updated_at",                                                                  null: false
    t.string   "hours",                     limit: 500
    t.string   "outbound_call_outcome",                                          default: "", null: false
    t.string   "caller_phone_number"
  end

  create_table "uploaded_files", force: :cascade do |t|
    t.string   "upload_type", default: "",    null: false
    t.string   "filename",    default: "",    null: false
    t.boolean  "processed",   default: false, null: false
    t.binary   "data",                        null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "uid"
    t.string   "organisation_slug"
    t.string   "organisation_content_id"
    t.string   "permissions"
    t.boolean  "remotely_signed_out",     default: false
    t.boolean  "disabled",                default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "where_did_you_hears", force: :cascade do |t|
    t.datetime "given_at",                           null: false
    t.string   "delivery_partner",                   null: false
    t.string   "heard_from",            default: "", null: false
    t.string   "pension_provider",      default: "", null: false
    t.string   "location",              default: "", null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "uid",                   default: "", null: false
    t.string   "heard_from_raw",        default: "", null: false
    t.string   "heard_from_code",       default: "", null: false
    t.string   "pension_provider_code", default: "", null: false
    t.jsonb    "raw_uid"
  end

  create_table "year_months", force: :cascade do |t|
    t.string   "value"
    t.string   "short_format"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_foreign_key "costs", "cost_items"
  add_foreign_key "costs", "users"
end
