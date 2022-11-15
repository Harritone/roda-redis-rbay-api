# frozen_string_literal: true

# {AuthorizationTokensGenerator} generates access and refresh token for {User}.
class AuthorizationTokensGenerator
  # @param [User] user for whom access and refresh token will be generated.
  def initialize(user:)
    @user = user
  end

  def call
    {
      access_token: { token: access_token, expires_in: ENV.fetch('ACCESS_TOKEN_EXPIRES_IN', 300).to_i },
      refresh_token: { token: refresh_token, expires_in: ENV.fetch('REFRESH_TOKEN_EXPIRES_IN', 900).to_i }
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
