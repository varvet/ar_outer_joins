require "active_record"
require "ar_outer_join/version"

module ArOuterJoin
  def outer_join(*args)
    return self if args.compact.blank?

    args.inject(self) do |scope, arg|
      association = reflect_on_association(arg)

      case association.macro
      when :belongs_to
        on = Arel::Nodes::On.new(arel_table[association.foreign_key].eq(association.klass.arel_table[primary_key]))
        outer_join = Arel::Nodes::OuterJoin.new(association.klass.arel_table, on)
      else
        on = Arel::Nodes::On.new(association.klass.arel_table[association.foreign_key].eq(arel_table[primary_key]))
        outer_join = Arel::Nodes::OuterJoin.new(association.klass.arel_table, on)
      end
      scope.joins(outer_join)
    end
  end
end

ActiveRecord::Base.extend ArOuterJoin
