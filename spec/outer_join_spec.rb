require "spec_helper"

class Product < ActiveRecord::Base
  belongs_to :category
  belongs_to :site
  has_many :line_items
  has_many :baskets, :through => :line_items
  has_many :discounts, :through => :line_items
  has_and_belongs_to_many :tags
  has_one :image
end

class LineItem < ActiveRecord::Base
  belongs_to :basket
  belongs_to :product
  has_many :discounts
end

class Image < ActiveRecord::Base
  belongs_to :product
end

class Basket < ActiveRecord::Base; end
class Category < ActiveRecord::Base; end
class Site < ActiveRecord::Base; end
class Discount < ActiveRecord::Base; end
class Tag < ActiveRecord::Base; end

describe ActiveRecord::Base do
  describe ".outer_join" do
    context "with belongs_to" do
      it "performs an outer join" do
        category1 = Category.create! :name => "Shoes"
        category2 = Category.create! :name => "Shirts"
        product1 = Product.create! :category => category1
        product2 = Product.create! :category => category2
        product3 = Product.create! :published => true
        query = Product.outer_join(:category).where("categories.name = ? OR products.published = ?", "Shirts", true)
        query.all.should =~ [product2, product3]
      end

      it "joins several associations" do
        site1 = Site.create! :name => "Elabs"
        category1 = Category.create! :name => "Shoes"
        category2 = Category.create! :name => "Shirts"
        product1 = Product.create! :category => category1
        product2 = Product.create! :category => category2
        product3 = Product.create! :published => true
        product4 = Product.create! :site => site1
        query = Product.outer_join(:category, :site).where("sites.name = ? OR categories.name = ? OR products.published = ?", "Elabs", "Shirts", true)
        query.all.should =~ [product2, product3, product4]
      end
    end

    context "with has_one" do
      it "performs an outer join" do
        product1 = Product.create!
        product2 = Product.create!
        product3 = Product.create! :published => true
        product4 = Product.create!

        Image.create! :highres => true, :product => product1
        Image.create! :product => product2

        query = Product.outer_join(:image).where("images.highres = ? OR products.published = ?", true, true)
        query.all.should =~ [product1, product3]
      end
    end

    context "with has_many" do
      it "performs an outer join" do
        product1 = Product.create!
        product2 = Product.create!
        product3 = Product.create! :published => true
        product4 = Product.create!

        LineItem.create! :price => 4, :product => product1
        LineItem.create! :product => product2

        query = Product.outer_join(:line_items).where("line_items.price = ? OR products.published = ?", 4, true)
        query.all.should =~ [product1, product3]
      end
    end

    context "with has_and_belongs_to_many" do
      it "performs an outer join" do
        red = Tag.create! :name => "Red"
        blue = Tag.create! :name => "Blue"

        product1 = Product.create!
        product2 = Product.create! :tags => [red]
        product3 = Product.create! :tags => [red, blue]
        product4 = Product.create! :published => true


        query = Product.outer_join(:tags).where("tags.name = ? OR products.published = ?", "Red", true)
        query.all.should =~ [product2, product3, product4]
      end
    end

    context "with has_many :through" do
      it "performs an outer join" do
        product1 = Product.create!
        product2 = Product.create!
        product3 = Product.create! :published => true
        product4 = Product.create!

        basket1 = Basket.create! :purchased => true
        basket2 = Basket.create! :purchased => false

        LineItem.create! :product => product1, :basket => basket1
        LineItem.create! :product => product2, :basket => basket2
        LineItem.create! :product => product3

        query = Product.outer_join(:baskets).where("baskets.purchased = ? OR products.published = ?", true, true)
        query.all.should =~ [product1, product3]
      end
    end
  end
end
