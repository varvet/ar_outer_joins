require "active_record"
require "ar_outer_join/version"

module ArOuterJoin
  class OuterJoinError < StandardError; end

  class Join
    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    def apply(*args)
      return klass if args.compact.blank?

      args.inject(klass) do |scope, arg|
        association = klass.reflect_on_association(arg)

        if association.is_a? ActiveRecord::Reflection::ThroughReflection
          scope.joins(*construct_join(association.through_reflection)).
                joins(*construct_join(association.source_reflection))
        else
          scope.joins(*construct_join(association))
        end
      end
    end

  private

    def construct_join(association)
      table = association.active_record.arel_table
      primary_key = association.active_record.primary_key
      joined_table = association.klass.arel_table

      case association.macro
      when :belongs_to
        on = Arel::Nodes::On.new(table[association.foreign_key].eq(joined_table[primary_key]))
        [Arel::Nodes::OuterJoin.new(joined_table, on)]
      when :has_and_belongs_to_many
        join_model_table = Arel::Table.new(association.options[:join_table])
        joined_primary_key = association.klass.primary_key

        on1 = Arel::Nodes::On.new(join_model_table[association.foreign_key].eq(table[primary_key]))
        on2 = Arel::Nodes::On.new(join_model_table[association.association_foreign_key].eq(joined_table[joined_primary_key]))

        [Arel::Nodes::OuterJoin.new(join_model_table, on1), Arel::Nodes::OuterJoin.new(joined_table, on2)]
      when :has_many, :has_one
        on = Arel::Nodes::On.new(joined_table[association.foreign_key].eq(table[primary_key]))
        [Arel::Nodes::OuterJoin.new(joined_table, on)]
      else
        raise OuterJoinError, "don't know what to do with #{association.macro} association"
      end
    end
  end


  def outer_join(*args)
    Join.new(self).apply(*args)
  end
end

ActiveRecord::Base.extend ArOuterJoin
