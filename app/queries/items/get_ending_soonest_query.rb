# frozen_string_literal: true

module Items
  class GetEndingSoonestQuery
    include Redisable

    def initialize(offset = 0, count = 10)
      @offset = offset
      @count = count
    end

    def call
      ids = redis_zrevrangebyscore(items_by_ending_at_key, '+inf', Time.now.to_i, options: { limit: [@offset, @count] })
      redis_multi do |pipeline|
        res = []
        ids.each do |item_id|
          res << pipeline.hgetall(items_key(item_id))
        end
        res
      end
    end
  end
end
