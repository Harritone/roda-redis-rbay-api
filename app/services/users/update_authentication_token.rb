# frozen_string_literal: true

module Users
  class UpdateAuthenticationToken
    include Redisable
    def initialize(user:)
      @user = user
    end

    def call
      redis_multi do |pipeline|
        pipeline.hset(users_key(@user[:id]), { authentication_token: authentication_token } )
        pipeline.srem(uniq_auth_tokens_key, @user[:authentication_token])
        pipeline.sadd(uniq_auth_tokens_key, authentication_token)
      end
    end

    private

    def authentication_token
      @authentication_token ||= AuthenticationTokenGenerator.call
    end
  end
end
