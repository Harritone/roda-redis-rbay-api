# frozen_string_literal: true

require 'roda'

require_relative './system/boot'

class App < Roda
  plugin :environments

  plugin :heartbeat

  configure :development, :production do
    plugin :enhanced_logger
  end

  plugin :symbol_matchers

  plugin :error_handler

  plugin :default_headers,
         'Content-Type' => 'application/json',
         'Strict-Transport-Security' => 'max-age=16070400;',
         'X-Frame-Options' => 'deny',
         'X-Content-Type-Options' => 'nosniff',
         'X-XSS-Protection' => '1; mode=block'

  plugin :all_verbs

  def current_user
    return @current_user if @current_user

    purpose = request.url.include?('refresh_token') ? :refresh_token : :access_token

    @current_user = AuthorizationTokenValidator.new(
      authorization_token: env['HTTP_AUTHORIZATION'],
      purpose: purpose
    ).call
  end

  # Adds ability to automatically handle errors raised by the application.
  plugin :error_handler do |e|
    if e.instance_of?(Exceptions::InvalidParamsError)
      error_object    = e.object
      response.status = 422
    elsif e.instance_of?(Exceptions::UserExists)
      error_object    = { error: I18n.t('user_exists') }
      response.status = 422
    elsif e.instance_of?(Exceptions::UserNotFound)
      error_object    = { error: I18n.t('user_not_found') }
      response.status = 404
    elsif e.instance_of?(Exceptions::PasswordMismatch)
      error_object    = { error: I18n.t('password_mismatch') }
      response.status = 401
    elsif e.instance_of?(ActiveSupport::MessageVerifier::InvalidSignature)
      error_object    = { error: I18n.t('invalid_authorization_token') }
      response.status = 401
    else
      binding.pry
      error_object = { error: I18n.t('something_went_wrong') }
      response.status = 500
    end
    response.write(error_object.to_json)
  end

  # The json_parser plugin parses request bodies in JSON format if the request's content type specifies JSON.
  # This is mostly designed for use with JSON API sites.
  plugin :json_parser

  route do |r|
    r.on('api') do
      r.on('v1') do
        r.post('sign_up') do
          sign_up_params = SignUpParams.new.permit!(r.params)
          user           = Users::Creator.new(attributes: sign_up_params).call
          tokens         = AuthorizationTokensGenerator.new(user_id: user[:id]).call

          UserSerializer.new(user: user, tokens: tokens).render
        end

        r.post('login') do
          login_params = LoginParams.new.permit!(r.params)
          user         = Users::Authenticator.new(login_params).call
          tokens       = AuthorizationTokensGenerator.new(user_id: user[:id]).call

          UserSerializer.new(user: user, tokens: tokens).render
        end

        r.delete('logout') do
          Users::UpdateAuthenticationToken.new(user: current_user).call

          response.write(nil)
        end

        r.post('refresh_token') do
          Users::UpdateAuthenticationToken.new(user: current_user).call

          tokens = AuthorizationTokensGenerator.new(user_id: current_user[:id]).call

          TokensSerializer.new(tokens: tokens).render
        end
      end
    end
  end
end
