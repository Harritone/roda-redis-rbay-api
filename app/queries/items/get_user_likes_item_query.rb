# frozen_string_literal: true

module Items
  class GetUserLikesItemQuery
    include Redisable

    def initialize(item_id, user_id)
      @item_id = item_id
      @user_id = user_id
    end

    def call
      redis_sismember(user_likes_key(@user_id), @item_id)
    end
  end
end
