# frozen_string_literal: true

class RefreshTokenGenerator
  # @param [User] user
  def initialize(user:)
    @user = user
  end

  def call
    data = { user_id: @user[:id], authentication_token: @user[:authentication_token] }

    MessageVerifier.encode(data: data, expires_at: Time.now + 900, purpose: :refresh_token)
  end
end
