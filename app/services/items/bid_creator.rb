# frozen_string_literal: true

module Items
  class BidCreator
    include Redisable
    include Import['redis.redlock', 'logger']

    def call(amount:, item:, user_id:)
      lock_key = "lock:#{item[:id]}"
      redlock.lock(lock_key, 2000) do |locked|
        if locked
          if (Integer(item[:ending_at], 10) - Time.now.to_i).negative?
            logger.warn 'Item closed to bidding'
            raise Exceptions::BidException.new('Item closed to bidding')
          end
          raise Exceptions::BidException.new('Price is too low') if Float(item[:price]) >= amount

          redis_multi do |pipeline|
            pipeline.rpush(bid_history_key(item[:id]), "#{amount}:#{Time.now.to_i}")
            pipeline.hset(
              items_key(item[:id]),
              {
                bids: Integer(item[:bids], 10) + 1,
                price: amount,
                highest_bid_user_id: user_id
              }
            )
            pipeline.zadd(items_by_price_key, amount, item[:id])
          end
        else
          logger.warn 'Lock expired, cannot write anymore data'
          raise Exceptions::BidException.new('Try again later')
        end
      end
    end
  end
end
