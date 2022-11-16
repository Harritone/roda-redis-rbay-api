# frozen_string_literal: true

module Users
  class GetUserByIdQuery
    include Redisable

    def initialize(user_id)
      @user_id = user_id
    end

    def call
      user = redis_hgetall(users_key(@user_id))
      raise Exceptions::NotFound unless user.present?
      user.symbolize_keys.merge(id: @user_id)
    end
  end
end
