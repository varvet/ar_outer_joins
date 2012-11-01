module ArOuterJoin
  class Join
    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    def generate(*args)
      args.compact.map do |arg|
        JoinBuilder.new(klass.reflect_on_association(arg)).build
      end
    end

    def apply(*args)
      klass.joins(generate(*args))
    end
  end
end
