# frozen_string_literal: true

class AccessTokenGenerator
  # @param [User] user
  def initialize(user:)
    @user = user
  end

  def call
    data = { user_id: @user[:id], authentication_token: @user[:authentication_token] }

    MessageVerifier.encode(data: data, expires_at: Time.now + ENV.fetch('ACCESS_TOKEN_EXPIRES_IN', 300).to_i , purpose: :access_token)
  end
end
