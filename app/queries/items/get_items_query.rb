# frozen_string_literal: true

module Items
  class GetItemsQuery
    include Redisable

    def initialize(ids)
      @ids = ids
    end

    def call
      result = redis_multi do |pipeline|
        res = []

        @ids.each do |id|
          res << pipeline.hgetall(items_key(id))
        end

        res
      end

      result
    end
  end
end
