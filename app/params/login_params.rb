class LoginParams < ApplicationParams
  params do
    required(:username).filled(:string).value(format?: Constants::EMAIL_REGEX)
    required(:password).filled(:string)
  end
end
