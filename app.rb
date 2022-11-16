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
    elsif e.instance_of?(Exceptions::NotFound)
      error_object    = { error: I18n.t('not_found') }
      response.status = 401
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
        r.is 'start_info' do
          r.get do
            RootSerializer.new.render
          end
        end
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

        r.on('items') do
          current_user

          r.is do
            r.post do
              item_params = Items::ItemParams.new.permit!(r.params)
              item_id     = Items::Creator.new(user: current_user, attributes: item_params).call
              { id: item_id }.to_json
            end
          end

          r.on(:item_id) do |item_id|
            r.get do
              item = Items::GetItemQuery.new(item_id).call
              Views::ItemViewIncrementor.new(item[:id],current_user[:id]).call

              ItemSerializer.new(item: item, user_id: current_user[:id]).render
            end

            r.is 'like' do
              r.post  do
                Items::ItemLiker.new(item_id, current_user[:id]).call
                item = Items::GetItemQuery.new(item_id).call
                ItemSerializer.new(item: item, user_id: current_user[:id]).render
              end

              r.delete do
                Items::ItemUnliker.new(item_id, current_user[:id]).call
                item = Items::GetItemQuery.new(item_id).call
                ItemSerializer.new(item: item, user_id: current_user[:id]).render
              end
            end

          end
        end

        r.on('users') do
          current_user

          r.on(:user_id) do |id|
            r.get do
              user = Users::GetUserByIdQuery.new(id).call
              UserShowSerializer.new(user: user, current_user_id: current_user[:id]).render
            end
          end
        end
      end
    end
  end
end
