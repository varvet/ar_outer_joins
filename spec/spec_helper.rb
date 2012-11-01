require "active_record"
require "ar_outer_join"
require "pry"

ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ":memory:"

ActiveRecord::Base.connection.create_table :products do |t|
  t.integer :category_id
  t.integer :site_id
  t.boolean :published, :default => false, :null => false
end

ActiveRecord::Base.connection.create_table :line_items do |t|
  t.integer :product_id
  t.integer :basket_id
  t.integer :discount_id
end

ActiveRecord::Base.connection.create_table :baskets

ActiveRecord::Base.connection.create_table :categories do |t|
  t.string :name
end

ActiveRecord::Base.connection.create_table :sites do |t|
  t.string :name
end

ActiveRecord::Base.connection.create_table :discounts

ActiveRecord::Base.connection.create_table :users

RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
