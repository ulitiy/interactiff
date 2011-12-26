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

ActiveRecord::Schema.define(:version => 20110831221336) do

  create_table "answers", :force => true do |t|
    t.string  "body"
    t.integer "task_id"
  end

  add_index "answers", ["task_id"], :name => "index_answers_on_task_id"

  create_table "blocks", :force => true do |t|
    t.string   "type"
    t.integer  "x"
    t.integer  "y"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blocks", ["parent_id"], :name => "index_blocks_on_parent_id"

  create_table "domains", :force => true do |t|
    t.string  "name"
    t.integer "main_host_id"
  end

  add_index "domains", ["main_host_id"], :name => "index_domains_on_main_host_id"

  create_table "games", :force => true do |t|
    t.string  "name"
    t.text    "description"
    t.integer "domain_id"
  end

  add_index "games", ["domain_id"], :name => "index_games_on_domain_id"

  create_table "hints", :force => true do |t|
    t.text    "body"
    t.integer "task_id"
  end

  add_index "hints", ["task_id"], :name => "index_hints_on_task_id"

  create_table "hosts", :force => true do |t|
    t.string   "name"
    t.integer  "domain_id"
    t.integer  "main_host_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hosts", ["domain_id"], :name => "index_hosts_on_domain_id"
  add_index "hosts", ["main_host_id"], :name => "index_hosts_on_main_host_id"

  create_table "tasks", :force => true do |t|
    t.string  "name"
    t.text    "comment"
    t.integer "weight"
    t.integer "game_id"
  end

  add_index "tasks", ["game_id"], :name => "index_tasks_on_game_id"

  create_view "view_answers", "select `blocks`.`id` AS `id`,`blocks`.`type` AS `type`,`blocks`.`x` AS `x`,`blocks`.`y` AS `y`,`blocks`.`parent_id` AS `parent_id`,`blocks`.`created_at` AS `created_at`,`blocks`.`updated_at` AS `updated_at`,`answers`.`body` AS `body`,`answers`.`task_id` AS `task_id` from (`blocks` join `answers`) where (`blocks`.`id` = `answers`.`id`)", :force => true do |v|
    v.column :id
    v.column :type
    v.column :x
    v.column :y
    v.column :parent_id
    v.column :created_at
    v.column :updated_at
    v.column :body
    v.column :task_id
  end

  create_view "view_domains", "select `blocks`.`id` AS `id`,`blocks`.`type` AS `type`,`blocks`.`x` AS `x`,`blocks`.`y` AS `y`,`blocks`.`parent_id` AS `parent_id`,`blocks`.`created_at` AS `created_at`,`blocks`.`updated_at` AS `updated_at`,`domains`.`name` AS `name`,`domains`.`main_host_id` AS `main_host_id` from (`blocks` join `domains`) where (`blocks`.`id` = `domains`.`id`)", :force => true do |v|
    v.column :id
    v.column :type
    v.column :x
    v.column :y
    v.column :parent_id
    v.column :created_at
    v.column :updated_at
    v.column :name
    v.column :main_host_id
  end

  create_view "view_games", "select `blocks`.`id` AS `id`,`blocks`.`type` AS `type`,`blocks`.`x` AS `x`,`blocks`.`y` AS `y`,`blocks`.`parent_id` AS `parent_id`,`blocks`.`created_at` AS `created_at`,`blocks`.`updated_at` AS `updated_at`,`games`.`name` AS `name`,`games`.`description` AS `description`,`games`.`domain_id` AS `domain_id` from (`blocks` join `games`) where (`blocks`.`id` = `games`.`id`)", :force => true do |v|
    v.column :id
    v.column :type
    v.column :x
    v.column :y
    v.column :parent_id
    v.column :created_at
    v.column :updated_at
    v.column :name
    v.column :description
    v.column :domain_id
  end

  create_view "view_hints", "select `blocks`.`id` AS `id`,`blocks`.`type` AS `type`,`blocks`.`x` AS `x`,`blocks`.`y` AS `y`,`blocks`.`parent_id` AS `parent_id`,`blocks`.`created_at` AS `created_at`,`blocks`.`updated_at` AS `updated_at`,`hints`.`body` AS `body`,`hints`.`task_id` AS `task_id` from (`blocks` join `hints`) where (`blocks`.`id` = `hints`.`id`)", :force => true do |v|
    v.column :id
    v.column :type
    v.column :x
    v.column :y
    v.column :parent_id
    v.column :created_at
    v.column :updated_at
    v.column :body
    v.column :task_id
  end

  create_view "view_tasks", "select `blocks`.`id` AS `id`,`blocks`.`type` AS `type`,`blocks`.`x` AS `x`,`blocks`.`y` AS `y`,`blocks`.`parent_id` AS `parent_id`,`blocks`.`created_at` AS `created_at`,`blocks`.`updated_at` AS `updated_at`,`tasks`.`name` AS `name`,`tasks`.`comment` AS `comment`,`tasks`.`weight` AS `weight`,`tasks`.`game_id` AS `game_id` from (`blocks` join `tasks`) where (`blocks`.`id` = `tasks`.`id`)", :force => true do |v|
    v.column :id
    v.column :type
    v.column :x
    v.column :y
    v.column :parent_id
    v.column :created_at
    v.column :updated_at
    v.column :name
    v.column :comment
    v.column :weight
    v.column :game_id
  end

end
