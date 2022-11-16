# frozen_string_literal: true

module Items
  class ItemUnliker
    include Redisable

    def initialize(item_id, user_id)
      @item_id = item_id
      @user_id = user_id
    end

    def call
      removed = redis_srem(user_likes_key(@user_id), @item_id)
      redis_hincrby(items_key(@item_id), 'likes', -1) if removed
    end
  end
end

