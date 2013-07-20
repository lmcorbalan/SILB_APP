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

ActiveRecord::Schema.define(:version => 20130717204649) do

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "ancestry"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "state"
  end

  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.integer  "region_id"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "line_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "unit_price_cents"
    t.integer  "quantity"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "order_payments", :force => true do |t|
    t.integer  "order_id"
    t.string   "ip_address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "express_token"
    t.string   "express_payer_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.string   "state"
    t.datetime "purchased_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "payment_transactions", :force => true do |t|
    t.integer  "order_payment_id"
    t.string   "action"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "params"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "pictures", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.integer  "category_id"
    t.integer  "brand_id"
    t.integer  "price_cents"
    t.integer  "current_stock"
    t.integer  "minimum_stock"
    t.integer  "highlight_stock_from"
    t.string   "state"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "products", ["code"], :name => "index_products_on_code", :unique => true
  add_index "products", ["name"], :name => "index_products_on_name", :unique => true

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shipping_addresses", :force => true do |t|
    t.integer  "order_id"
    t.string   "reference_name"
    t.string   "reference_last_name"
    t.string   "company_name"
    t.string   "reference_phone"
    t.integer  "shipping_cost_id"
    t.string   "zip_code"
    t.string   "shipping_address_1"
    t.string   "shipping_address_2"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "shipping_costs", :force => true do |t|
    t.text     "description"
    t.string   "state"
    t.integer  "shipping_method_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "city_id"
    t.integer  "price_cents",        :default => 0
  end

  create_table "shipping_methods", :force => true do |t|
    t.string   "name"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "state"
    t.string   "activation_token"
    t.integer  "roles_mask"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
