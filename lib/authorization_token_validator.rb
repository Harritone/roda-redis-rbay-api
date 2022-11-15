# frozen_string_literal: true

class AuthorizationTokenValidator
  include Redisable

  def initialize(authorization_token:, purpose:)
    @authorization_token = authorization_token
    @purpose = purpose
  end

  def call
    unless current_user && current_user[:authentication_token] == data[:authentication_token]
      raise(ActiveSupport::MessageVerifier::InvalidSignature)
    end

    current_user.merge(id: data[:user_id])
  end

  private

  def data
    @data ||= MessageVerifier.decode(message: @authorization_token, purpose: @purpose)
  end

  def current_user
    @current_user ||= redis_hgetall(users_key(data[:user_id]))&.symbolize_keys
  end
end
