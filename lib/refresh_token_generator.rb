# frozen_string_literal: true

class RefreshTokenGenerator
  # @param [User] user
  def initialize(user:)
    @user = user
  end

  def call
    data = { user_id: @user[:id], authentication_token: @user[:authentication_token] }

    MessageVerifier.encode(
      data: data,
      expires_at: Time.now + Integer(ENV.fetch('REFRESH_TOKEN_EXPIRES_IN', 900), 10),
      purpose: :refresh_token
    )
  end
end
