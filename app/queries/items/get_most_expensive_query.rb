# frozen_string_literal: true

module Items
  class GetMostExpensiveQuery
    include Redisable

    def initialize(order = 'DESC', offset = 0, count = 10)
      @order = order
      @offset = offset
      @count = count
    end

    def call
      get = [
        '#',
        "#{items_key('*')}->name",
        "#{items_key('*')}->views",
        "#{items_key('*')}->ending_at",
        "#{items_key('*')}->image_url",
        "#{items_key('*')}->price"
      ]

      results = redis_sort(items_by_price_key, get: get, by: 'NOSORT', order: @order, limit: [@offset, @count])

      items = []

      results.each do |result|
        items << {
          id: result[0],
          name: result[1],
          views: result[2],
          ending_at: result[3],
          image_url: result[4],
          price: result[5]
        }
      end

      items
    end
  end
end
