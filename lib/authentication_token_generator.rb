# frozen_string_literal: true

# {AuthenticationTokenGenerator} generates unique authentication token for {User}.
module AuthenticationTokenGenerator
  include Redisable

  def self.call
    loop do
      random_token = SecureRandom.hex(20)
      break random_token unless redis_sismember(uniq_auth_tokens_key, random_token)
    end
  end
end
