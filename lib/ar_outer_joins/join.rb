module ArOuterJoins
  class Join
    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    def generate(*args)
      args.flatten.compact.map do |arg|
        if arg.is_a?(Hash)
          arg.map do |key, value|
            association = klass.reflect_on_association(key)
            generate(key) + Join.new(association.klass).generate(value)
          end
        else
          JoinBuilder.new(klass.reflect_on_association(arg)).build
        end
      end
    end

    def apply(*args)
      klass.joins(generate(*args))
    end
  end
end
