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

ActiveRecord::Schema.define(:version => 20120313202255) do

  create_table "answers", :force => true do |t|
    t.string "body"
  end

  create_table "blocks", :force => true do |t|
    t.string   "type"
    t.integer  "x"
    t.integer  "y"
    t.integer  "parent_id"
    t.integer  "game_id"
    t.integer  "task_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "blocks", ["game_id"], :name => "index_blocks_on_game_id"
  add_index "blocks", ["parent_id"], :name => "index_blocks_on_parent_id"
  add_index "blocks", ["task_id"], :name => "index_blocks_on_task_id"

  create_table "domains", :force => true do |t|
    t.string  "name"
    t.integer "main_host_id"
  end

  add_index "domains", ["main_host_id"], :name => "index_domains_on_main_host_id"

  create_table "games", :force => true do |t|
    t.string "name"
    t.text   "description"
  end

  create_table "hints", :force => true do |t|
    t.text "body"
  end

  create_table "hosts", :force => true do |t|
    t.string "name"
  end

  create_table "relations", :force => true do |t|
    t.integer  "to_id"
    t.integer  "from_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "game_id"
  end

  add_index "relations", ["from_id"], :name => "index_relations_on_from_id"
  add_index "relations", ["game_id"], :name => "index_relations_on_game_id"
  add_index "relations", ["to_id"], :name => "index_relations_on_to_id"

  create_table "tasks", :force => true do |t|
    t.string "name"
    t.text   "comment"
  end

  create_view "view_answers", "select `blocks`.`id` AS `id`,`blocks`.`type` AS `type`,`blocks`.`x` AS `x`,`blocks`.`y` AS `y`,`blocks`.`parent_id` AS `parent_id`,`blocks`.`game_id` AS `game_id`,`blocks`.`task_id` AS `task_id`,`blocks`.`created_at` AS `created_at`,`blocks`.`updated_at` AS `updated_at`,`answers`.`body` AS `body` from (`blocks` join `answers`) where (`blocks`.`id` = `answers`.`id`)", :force => true do |v|
    v.column :id
    v.column :type
    v.column :x
    v.column :y
    v.column :parent_id
    v.column :game_id
    v.column :task_id
    v.column :created_at
    v.column :updated_at
    v.column :body
  end

  create_view "view_domains", "select `blocks`.`id` AS `id`,`blocks`.`type` AS `type`,`blocks`.`x` AS `x`,`blocks`.`y` AS `y`,`blocks`.`parent_id` AS `parent_id`,`blocks`.`game_id` AS `game_id`,`blocks`.`task_id` AS `task_id`,`blocks`.`created_at` AS `created_at`,`blocks`.`updated_at` AS `updated_at`,`domains`.`name` AS `name`,`domains`.`main_host_id` AS `main_host_id` from (`blocks` join `domains`) where (`blocks`.`id` = `domains`.`id`)", :force => true do |v|
    v.column :id
    v.column :type
    v.column :x
    v.column :y
    v.column :parent_id
    v.column :game_id
    v.column :task_id
    v.column :created_at
    v.column :updated_at
    v.column :name
    v.column :main_host_id
  end

  create_view "view_games", "select `blocks`.`id` AS `id`,`blocks`.`type` AS `type`,`blocks`.`x` AS `x`,`blocks`.`y` AS `y`,`blocks`.`parent_id` AS `parent_id`,`blocks`.`game_id` AS `game_id`,`blocks`.`task_id` AS `task_id`,`blocks`.`created_at` AS `created_at`,`blocks`.`updated_at` AS `updated_at`,`games`.`name` AS `name`,`games`.`description` AS `description` from (`blocks` join `games`) where (`blocks`.`id` = `games`.`id`)", :force => true do |v|
    v.column :id
    v.column :type
    v.column :x
    v.column :y
    v.column :parent_id
    v.column :game_id
    v.column :task_id
    v.column :created_at
    v.column :updated_at
    v.column :name
    v.column :description
  end

  create_view "view_hints", "select `blocks`.`id` AS `id`,`blocks`.`type` AS `type`,`blocks`.`x` AS `x`,`blocks`.`y` AS `y`,`blocks`.`parent_id` AS `parent_id`,`blocks`.`game_id` AS `game_id`,`blocks`.`task_id` AS `task_id`,`blocks`.`created_at` AS `created_at`,`blocks`.`updated_at` AS `updated_at`,`hints`.`body` AS `body` from (`blocks` join `hints`) where (`blocks`.`id` = `hints`.`id`)", :force => true do |v|
    v.column :id
    v.column :type
    v.column :x
    v.column :y
    v.column :parent_id
    v.column :game_id
    v.column :task_id
    v.column :created_at
    v.column :updated_at
    v.column :body
  end

  create_view "view_hosts", "select `blocks`.`id` AS `id`,`blocks`.`type` AS `type`,`blocks`.`x` AS `x`,`blocks`.`y` AS `y`,`blocks`.`parent_id` AS `parent_id`,`blocks`.`game_id` AS `game_id`,`blocks`.`task_id` AS `task_id`,`blocks`.`created_at` AS `created_at`,`blocks`.`updated_at` AS `updated_at`,`hosts`.`name` AS `name` from (`blocks` join `hosts`) where (`blocks`.`id` = `hosts`.`id`)", :force => true do |v|
    v.column :id
    v.column :type
    v.column :x
    v.column :y
    v.column :parent_id
    v.column :game_id
    v.column :task_id
    v.column :created_at
    v.column :updated_at
    v.column :name
  end

  create_view "view_tasks", "select `blocks`.`id` AS `id`,`blocks`.`type` AS `type`,`blocks`.`x` AS `x`,`blocks`.`y` AS `y`,`blocks`.`parent_id` AS `parent_id`,`blocks`.`game_id` AS `game_id`,`blocks`.`task_id` AS `task_id`,`blocks`.`created_at` AS `created_at`,`blocks`.`updated_at` AS `updated_at`,`tasks`.`name` AS `name`,`tasks`.`comment` AS `comment` from (`blocks` join `tasks`) where (`blocks`.`id` = `tasks`.`id`)", :force => true do |v|
    v.column :id
    v.column :type
    v.column :x
    v.column :y
    v.column :parent_id
    v.column :game_id
    v.column :task_id
    v.column :created_at
    v.column :updated_at
    v.column :name
    v.column :comment
  end

end
