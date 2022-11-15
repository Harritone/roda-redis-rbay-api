# frozen_string_literal: true

module Users
  class Authenticator
    include Redisable

    def initialize(opts)
      @username = opts[:username]
      @password = opts[:password]
    end

    def call
      decimal_id = redis_zscore(usernames_key, @username)

      raise Exceptions::UserNotFound unless decimal_id

      id = decimal_id.to_i.to_s(16)

      user = redis_hgetall(users_key(id))
      raise Exceptions::PasswordMismatch unless password_match?(user)
      user.symbolize_keys.merge(id: id)
    end

    private

    def password_match?(user)
      BCrypt::Password.new(user['password']) == @password
    end
  end
end
