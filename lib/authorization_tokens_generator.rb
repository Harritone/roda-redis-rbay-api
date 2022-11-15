# frozen_string_literal: true

class AuthorizationTokensGenerator
  include Redisable

  def initialize(user_id:)
    @user_id = user_id
  end

  def call
    {
      access_token: { token: access_token, expires_in: ENV.fetch('ACCESS_TOKEN_EXPIRES_IN', 300).to_i },
      refresh_token: { token: refresh_token, expires_in: ENV.fetch('REFRESH_TOKEN_EXPIRES_IN', 900).to_i }
    }
  end

  def user
    (redis_hgetall(users_key(@user_id)) || {}).symbolize_keys.merge(id: @user_id)
  end

  private

  def refresh_token
    RefreshTokenGenerator.new(user: user).call
  end

  def access_token
    AccessTokenGenerator.new(user: user).call
  end
end
