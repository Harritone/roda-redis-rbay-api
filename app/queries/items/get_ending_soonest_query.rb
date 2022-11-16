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
      result =
        redis_multi do |pipeline|
          ids.each do |item_id|
            pipeline.hgetall(items_key(item_id))
          end
        end

      result.map.with_index do |item, i|
        item.merge(id: ids[i]).symbolize_keys
      end
    end
  end
end
