# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  def to_json
    binding.pry
    {
      user: user,
      tokens: @tokens
    }
  end

  private

  def user
    {
      id: @user[:id],
      username: @user[:username],
    }
  end
end
