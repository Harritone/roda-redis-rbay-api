# frozen_string_literal: true

module Items
  class GetCommonLikedItemsQuery
    include Redisable

    def initialize(user_id, current_user_id)
      @user_id = user_id
      @current_user_id = current_user_id
    end

    def call
      ids = redis_sinter([user_likes_key(@user_id), user_likes_key(@current_user_id)])
      GetItemsQuery.new(ids).call
    end
  end
end
