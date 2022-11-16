# frozen_string_literal: true

module Items
  class ItemLiker
    include Redisable

    def initialize(item_id, user_id)
      @item_id = item_id
      @user_id = user_id
    end

    def call
      inserted = redis_sadd(user_likes_key(@user_id), @item_id)
      redis_hincrby(items_key(@item_id), 'likes', 1) if inserted
    end
  end
end
