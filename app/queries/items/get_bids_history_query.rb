# frozen_string_literal: true

module Items
  class GetBidsHistoryQuery
    include Redisable

    def initialize(item_id, offset = 0, count = 10)
      @item_id = item_id
      @offset = offset
      @count = count
    end

    def call
      start_index = -1 * @offset - @count
      end_index = -1 - @offset

      range = redis_lrange(bid_history_key(@item_id), start_index, end_index)
      range.map do |bid|
        amount, created_at = bid.split(':')
        {
          amount: Float(amount),
          created_at: Integer(created_at)
        }
      end
    end
  end
end
