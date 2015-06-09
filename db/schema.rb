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

ActiveRecord::Schema.define(version: 20150505105107) do

  create_table "activities", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.text     "book_table_isbn_list", limit: 65535
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "administrator_types", force: :cascade do |t|
    t.string   "name",       limit: 20
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "administrators", force: :cascade do |t|
    t.string   "email",                 limit: 100,                null: false
    t.string   "password_digest",       limit: 100,                null: false
    t.string   "first_name",            limit: 100
    t.string   "last_name",             limit: 100
    t.string   "nickname",              limit: 20
    t.integer  "administrator_type_id", limit: 4,                  null: false
    t.boolean  "active",                limit: 1,   default: true
    t.string   "web_session_id",        limit: 255
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "administrators", ["email"], name: "index_administrators_on_email", using: :btree

  create_table "advertises", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "url",        limit: 65535
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "author_require_join_publishes", force: :cascade do |t|
    t.integer  "author_id",          limit: 4
    t.integer  "publish_company_id", limit: 4
    t.boolean  "confirm",            limit: 1, default: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "authors", force: :cascade do |t|
    t.string   "email",                limit: 100,                  null: false
    t.string   "password_digest",      limit: 100
    t.string   "first_name",           limit: 100
    t.string   "last_name",            limit: 100
    t.string   "nickname",             limit: 20
    t.date     "birthday"
    t.boolean  "gender",               limit: 1
    t.text     "book_table_isbn_list", limit: 65535
    t.boolean  "active",               limit: 1,     default: true
    t.string   "web_session_id",       limit: 255
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "authors", ["email"], name: "index_authors_on_email", using: :btree

  create_table "black_lists", force: :cascade do |t|
    t.integer  "member_table_number", limit: 4
    t.integer  "member_table_id",     limit: 4
    t.integer  "book_series_id",      limit: 4
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "book_sales_account_types", force: :cascade do |t|
    t.string   "name",       limit: 20
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "book_sales_accounts", force: :cascade do |t|
    t.string   "email",           limit: 100,                  null: false
    t.string   "password_digest", limit: 100
    t.string   "first_name",      limit: 100
    t.string   "last_name",       limit: 100
    t.string   "nickname",        limit: 20
    t.date     "birthday"
    t.text     "publish_id_list", limit: 65535
    t.boolean  "active",          limit: 1,     default: true
    t.string   "web_session_id",  limit: 255
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "book_sales_accounts", ["email"], name: "index_book_sales_accounts_on_email", using: :btree

  create_table "book_series", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.integer  "publish_company_id", limit: 4
    t.text     "author_id_list",     limit: 65535
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "book_table_1s", force: :cascade do |t|
    t.string   "name",                   limit: 255,                   null: false
    t.string   "isbn",                   limit: 13,                    null: false
    t.integer  "graph_count",            limit: 4
    t.text     "author_name_list",       limit: 65535
    t.text     "translator_name_list",   limit: 65535
    t.integer  "book_series_id",         limit: 4
    t.date     "publish_date"
    t.integer  "publish_company_id",     limit: 4
    t.float    "rating",                 limit: 24,    default: 0.0
    t.integer  "rating_count",           limit: 4,     default: 0
    t.integer  "language_id",            limit: 4
    t.integer  "category_id",            limit: 4
    t.integer  "category_item_id",       limit: 4
    t.text     "content_introduction",   limit: 65535
    t.integer  "page_number",            limit: 4
    t.integer  "classification_type_id", limit: 4
    t.text     "fans_list",              limit: 65535
    t.integer  "fans_count",             limit: 4,     default: 0
    t.text     "activity_id_list",       limit: 65535
    t.boolean  "active",                 limit: 1,     default: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "book_table_1s", ["isbn"], name: "index_book_table_1s_on_isbn", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "category_items", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.integer  "category_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "classification_types", force: :cascade do |t|
    t.string   "name",       limit: 5
    t.text     "warning",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "forum_mangers", force: :cascade do |t|
    t.integer  "author_id",      limit: 4
    t.integer  "book_series_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "languages", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "member_rating_table_1s", force: :cascade do |t|
    t.string   "book_isbn",           limit: 13
    t.integer  "member_table_number", limit: 4
    t.integer  "member_table_id",     limit: 4
    t.integer  "rating",              limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "member_table_1s", force: :cascade do |t|
    t.string   "email",             limit: 100,                   null: false
    t.string   "password_digest",   limit: 100,                   null: false
    t.string   "first_name",        limit: 100
    t.string   "last_name",         limit: 100
    t.string   "nickname",          limit: 20
    t.date     "birthday"
    t.boolean  "gender",            limit: 1
    t.boolean  "active",            limit: 1,     default: true
    t.string   "web_session_id",    limit: 255
    t.string   "phone_session_id",  limit: 255
    t.text     "favorite_list",     limit: 65535
    t.boolean  "read_message",      limit: 1,     default: false
    t.datetime "read_message_date"
    t.string   "table_number",      limit: 2,     default: "1"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "member_table_1s", ["email"], name: "index_member_table_1s_on_email", using: :btree

  create_table "member_table_2s", force: :cascade do |t|
    t.string   "email",             limit: 100,                   null: false
    t.string   "password_digest",   limit: 100,                   null: false
    t.string   "first_name",        limit: 100
    t.string   "last_name",         limit: 100
    t.string   "nickname",          limit: 20
    t.date     "birthday"
    t.boolean  "gender",            limit: 1
    t.boolean  "active",            limit: 1,     default: true
    t.string   "web_session_id",    limit: 255
    t.string   "phone_session_id",  limit: 255
    t.text     "favorite_list",     limit: 65535
    t.boolean  "read_message",      limit: 1,     default: false
    t.datetime "read_message_date"
    t.string   "table_number",      limit: 2,     default: "2"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "member_table_2s", ["email"], name: "index_member_table_2s_on_email", using: :btree

  create_table "post_table_1s", force: :cascade do |t|
    t.integer  "book_series_id",      limit: 4
    t.string   "subject",             limit: 255
    t.text     "content",             limit: 65535
    t.integer  "author_id",           limit: 4
    t.integer  "member_table_number", limit: 4
    t.integer  "member_table_id",     limit: 4
    t.string   "poster_nickname",     limit: 20
    t.integer  "viewer",              limit: 4
    t.boolean  "sticky",              limit: 1
    t.datetime "last_reply_time"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "publish_companies", force: :cascade do |t|
    t.string   "name",                   limit: 50,    null: false
    t.text     "address",                limit: 65535
    t.text     "manager_master_id_list", limit: 65535
    t.text     "manager_sales_id_list",  limit: 65535
    t.text     "sales_id_list",          limit: 65535
    t.text     "author_id_list",         limit: 65535
    t.string   "tel",                    limit: 15
    t.string   "fax",                    limit: 15
    t.string   "email",                  limit: 100
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "publish_companies", ["name"], name: "index_publish_companies_on_name", using: :btree

  create_table "reply_table_1s", force: :cascade do |t|
    t.integer  "post_table_number",   limit: 4
    t.integer  "post_table_id",       limit: 4
    t.text     "content",             limit: 65535
    t.integer  "author_id",           limit: 4
    t.integer  "member_table_number", limit: 4
    t.integer  "member_table_id",     limit: 4
    t.string   "poster_nickname",     limit: 20
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "report_table_1s", force: :cascade do |t|
    t.integer  "report_from",        limit: 4
    t.integer  "report_to",          limit: 4
    t.integer  "post_table_number",  limit: 4
    t.integer  "post_table_id",      limit: 4
    t.integer  "reply_table_number", limit: 4
    t.integer  "reply_table_id",     limit: 4
    t.text     "reason",             limit: 65535
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "member_table_number", limit: 4
    t.integer  "member_table_id",     limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

end
