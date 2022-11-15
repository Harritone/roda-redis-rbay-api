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
end