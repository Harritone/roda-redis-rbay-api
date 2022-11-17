# frozen_string_literal: true

module Exceptions
  class InvalidParamsError < StandardError
    attr_reader :object

    def initialize(object, message)
      @object = object

      super(message)
    end
  end

  class InvalidEmailOrPassword < StandardError; end
  class UserExists < StandardError; end
  class UserNotFound < StandardError; end
  class NotFound < StandardError; end
  class BidException < StandardError; end
  class PasswordMismatch < StandardError; end
end
