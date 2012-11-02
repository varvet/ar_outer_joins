require "active_record"
require "ar_outer_joins/version"
require "ar_outer_joins/join_builder"
require "ar_outer_joins/join"

module ArOuterJoins
  def outer_joins(*joins)
    association_joins, regular_joins = joins.partition do |join|
      join.is_a?(Hash) or join.is_a?(Array) or join.is_a?(Symbol)
    end
    Join.new(self).apply(*association_joins).joins(*regular_joins)
  end
end

ActiveRecord::Base.extend ArOuterJoins
