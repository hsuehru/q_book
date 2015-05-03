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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150503041140) do

  create_table "activities", force: :cascade do |t|
    t.string   "name"
    t.text     "book_table_isbn_list"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "administrator_types", force: :cascade do |t|
    t.string   "name",       limit: 20
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "administrators", force: :cascade do |t|
    t.string   "email",                 limit: 100
    t.string   "password",              limit: 50
    t.string   "first_name",            limit: 100
    t.string   "last_name",             limit: 100
    t.string   "nickname",              limit: 20
    t.date     "birthday"
    t.integer  "administrator_type_id"
    t.boolean  "active"
    t.string   "web_session_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "advertises", force: :cascade do |t|
    t.string   "name"
    t.text     "url"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authors", force: :cascade do |t|
    t.string   "email",                limit: 100
    t.string   "password",             limit: 50
    t.string   "first_name",           limit: 100
    t.string   "last_name",            limit: 100
    t.string   "nickname",             limit: 20
    t.date     "birthday"
    t.boolean  "gender"
    t.text     "book_table_isbn_list"
    t.boolean  "active"
    t.string   "web_session_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "black_lists", force: :cascade do |t|
    t.integer  "member_table_number"
    t.integer  "member_table_id"
    t.integer  "book_series_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "book_sales_account_types", force: :cascade do |t|
    t.string   "name",       limit: 20
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "book_sales_accounts", force: :cascade do |t|
    t.string   "email",                      limit: 100
    t.string   "password",                   limit: 50
    t.string   "first_name",                 limit: 100
    t.string   "last_name",                  limit: 100
    t.string   "nickname",                   limit: 20
    t.date     "birthday"
    t.text     "publish_id_list"
    t.integer  "book_sales_account_type_id"
    t.boolean  "active"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "book_series", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "book_table_1s", force: :cascade do |t|
    t.string   "isbn",                   limit: 13
    t.integer  "graph_count"
    t.string   "name"
    t.text     "author_name_list"
    t.text     "translator_name_list"
    t.integer  "book_series_id"
    t.date     "publish_date"
    t.integer  "publish_company_id"
    t.float    "rating"
    t.integer  "rating_count"
    t.integer  "language_id"
    t.integer  "category_id"
    t.integer  "category_item_id"
    t.text     "content_introduction"
    t.integer  "page_number"
    t.integer  "classification_type_id"
    t.text     "fans_list"
    t.integer  "fans_count"
    t.text     "activity_id_list"
    t.boolean  "active"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "language_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "category_items", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "classification_types", force: :cascade do |t|
    t.string   "name",       limit: 5
    t.text     "warning"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "forum_mangers", force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "book_series_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "languages", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "member_rating_table_1s", force: :cascade do |t|
    t.string   "book_isbn",           limit: 13
    t.integer  "member_table_number"
    t.integer  "member_table_id"
    t.integer  "rating"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "member_table_1s", force: :cascade do |t|
    t.string   "email",             limit: 100
    t.string   "password",          limit: 50
    t.string   "first_name",        limit: 100
    t.string   "last_name",         limit: 100
    t.string   "nickname",          limit: 20
    t.date     "birthday"
    t.boolean  "gender"
    t.boolean  "active"
    t.string   "web_session_id"
    t.string   "phone_session_id"
    t.text     "favorite_list"
    t.boolean  "read_message"
    t.datetime "read_message_date"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "member_table_2s", force: :cascade do |t|
    t.string   "email",             limit: 100
    t.string   "password",          limit: 50
    t.string   "first_name",        limit: 100
    t.string   "last_name",         limit: 100
    t.string   "nickname",          limit: 20
    t.date     "birthday"
    t.boolean  "gender"
    t.boolean  "active"
    t.string   "web_session_id"
    t.string   "phone_session_id"
    t.text     "favorite_list"
    t.boolean  "read_message"
    t.datetime "read_message_date"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "post_table_1s", force: :cascade do |t|
    t.integer  "book_series_id"
    t.string   "subject"
    t.text     "content"
    t.integer  "author_id"
    t.integer  "member_table_number"
    t.integer  "member_table_id"
    t.integer  "viewer"
    t.boolean  "sticky"
    t.datetime "last_reply_time"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "publish_companies", force: :cascade do |t|
    t.string   "name",         limit: 50
    t.text     "address"
    t.text     "manager_list"
    t.text     "sales_list"
    t.string   "tel",          limit: 15
    t.string   "fax",          limit: 15
    t.string   "email",        limit: 100
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "reply_table_1s", force: :cascade do |t|
    t.integer  "post_table_number"
    t.integer  "post_table_id"
    t.text     "content"
    t.integer  "author_id"
    t.integer  "member_table_number"
    t.integer  "member_table_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "report_table_1s", force: :cascade do |t|
    t.integer  "report_from"
    t.integer  "report_to"
    t.integer  "post_table_number"
    t.integer  "post_table_id"
    t.integer  "reply_table_number"
    t.integer  "reply_table_id"
    t.text     "reason"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "member_table_number"
    t.integer  "member_table_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

end
