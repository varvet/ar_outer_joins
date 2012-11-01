module ArOuterJoin
  class Join
    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    def apply(*args)
      return klass if args.compact.blank?

      args.inject(klass) do |scope, arg|
        scope.joins(*JoinBuilder.new(klass.reflect_on_association(arg)).build)
      end
    end
  end
end
