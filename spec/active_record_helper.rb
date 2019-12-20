require 'active_record'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, force: true do |t|
    t.string :name
  end

  create_table :addresses, force: true do |t|
    t.string :city
    t.string :country
    t.integer :user_id
  end

  create_table :cars, force: true do |t|
    t.string :make
    t.integer :user_id
  end
end