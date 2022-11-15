# frozen_string_literal: true

class MessageVerifier
  class << self
    def encode(data:, expires_at:, purpose:)
      verifier.generate(data, expires_at: expires_at, purpose: purpose)
    end

    def decode(message:, purpose:)
      verifier.verify(message, purpose: purpose)
    end

    private

    def verifier
      ActiveSupport::MessageVerifier.new(ENV['SECRET_KEY_BASE'], digest: 'SHA512')
    end
  end
end
