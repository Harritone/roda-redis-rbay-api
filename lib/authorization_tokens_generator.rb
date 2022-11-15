# frozen_string_literal: true

# {AuthorizationTokensGenerator} generates access and refresh token for {User}.
class AuthorizationTokensGenerator
  # @param [User] user for whom access and refresh token will be generated.
  def initialize(user:)
    @user = user
  end

  def call
    {
      access_token: { token: access_token, expires_in: 300 },
      refresh_token: { token: refresh_token, expires_in: 900 }
    }
  end

  private

  def refresh_token
    RefreshTokenGenerator.new(user: @user).call
  end

  def access_token
    AccessTokenGenerator.new(user: @user).call
  end
end
