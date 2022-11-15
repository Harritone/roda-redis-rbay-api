# frozen_string_literal: true

module Items
  class Creator
    include Redisable

    def initialize(user:, attributes:)
      @user = user
      @attributes = attributes
    end

    def call
      serialized = {
        name: @attributes[:name],
        description: @attributes[:description],
        image_url: @attributes[:image_url],
        owner_id: @user[:id],
        created_at: Time.now.to_i,
        ending_at: Time.now.to_i + @attributes[:duration],
        highest_bid_user_id: '',
        price: 0,
        views: 0,
        likes: 0,
        bids: 0
      }

      redis_multi do |pipeline|
        pipeline.hset(items_key(id), serialized)
        pipeline.zadd(items_by_views_key, 0, id)
        pipeline.zadd(items_by_ending_at_key, serialized[:ending_at], id)
        pipeline.zadd(items_by_price_key, 0, id)
      end

      id
    end

    private

    def id
      @id ||= SecureRandom.hex(3)
    end
  end
end
