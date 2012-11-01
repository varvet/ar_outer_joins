require "active_record"
require "ar_outer_join/version"
require "ar_outer_join/join_builder"
require "ar_outer_join/join"

module ArOuterJoin
  def outer_join(*args)
    Join.new(self).apply(*args)
  end
end

ActiveRecord::Base.extend ArOuterJoin
