class SignUpParams < ApplicationParams
  params do
    required(:username).filled(:string).value(format?: Constants::EMAIL_REGEX)
    required(:password).filled(:string)
    required(:password_confirmation).filled(:string)
  end
end