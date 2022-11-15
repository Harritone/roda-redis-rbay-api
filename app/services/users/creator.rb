# frozen_string_literal: true

module Users
  # class UserExists < StandardError; end
  class Creator
    include Redisable

    def initialize(attributes:)
      @attributes = attributes
    end

    def call
      raise Exceptions::UserExists if exists?

      password_digest = BCrypt::Password.create(attributes[:password])
      params = {
        username: attributes[:username],
        password: password_digest,
        authentication_token: token
      }

      redis_multi do |pipeline|
        pipeline.hset(
          users_key(id),
          params
        )
        pipeline.sadd(usernames_uniq_key, attributes[:username])
        pipeline.sadd(uniq_auth_tokens_key, token)
        pipeline.zadd(usernames_key, Integer(id, 16), attributes[:username])
      end

      params.merge(id: id)
    end

    private

    attr_reader :attributes

    def id
      @id ||= SecureRandom.hex(3)
    end

    def token
      # Generate uniq token
      @token ||= AuthenticationTokenGenerator.call
    end


    def exists?
      redis_sismember(usernames_uniq_key, attributes[:username])
    end
  end
end
