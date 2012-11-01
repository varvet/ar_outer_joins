require "active_record"
require "ar_outer_joins/version"
require "ar_outer_joins/join_builder"
require "ar_outer_joins/join"

module ArOuterJoins
  def outer_joins(*args)
    Join.new(self).apply(*args)
  end
end

ActiveRecord::Base.extend ArOuterJoins
