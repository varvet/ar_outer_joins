require "spec_helper"

class Product < ActiveRecord::Base
  belongs_to :category
  belongs_to :site
  has_many :line_items
  has_many :baskets, :through => :line_items
  has_many :discounts, :through => :line_items
  has_one :user
end

class LineItem < ActiveRecord::Base
  belongs_to :baskets
  has_many :discounts
end

class Basket < ActiveRecord::Base; end
class Category < ActiveRecord::Base; end
class Site < ActiveRecord::Base; end
class User < ActiveRecord::Base; end
class Discount < ActiveRecord::Base; end

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
    end

    context "with several belongs_to" do
      it "performs an outer join" do
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
  end
end
