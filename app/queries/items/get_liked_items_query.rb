# frozen_string_literal: true

module Items
  class GetLikedItemsQuery
    include Redisable

    def initialize(user_id)
      @user_id = user_id
    end

    def call
      ids = redis_smembers(user_likes_key(@user_id))
      GetItemsQuery.new(ids).call
    end
  end
end
