require "active_record"
require "ar_outer_joins"
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
  t.integer :price, :default => 0, :null => false
end

ActiveRecord::Base.connection.create_table :baskets do |t|
  t.boolean :purchased, :default => false, :null => false
end

ActiveRecord::Base.connection.create_table :categories do |t|
  t.string :name
end

ActiveRecord::Base.connection.create_table :sites do |t|
  t.string :name
end

ActiveRecord::Base.connection.create_table :discounts do |t|
  t.integer :percentage, :default => 0, :null => false
  t.integer :line_item_id
end

ActiveRecord::Base.connection.create_table :tags do |t|
  t.string :name
end

ActiveRecord::Base.connection.create_table :products_tags, :id => false do |t|
  t.integer :product_id, :tag_id
end

ActiveRecord::Base.connection.create_table :images do |t|
  t.boolean :highres, :default => false, :null => false
  t.integer :product_id
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
