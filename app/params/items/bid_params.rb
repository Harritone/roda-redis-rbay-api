# frozen_string_literal: true

module Items
  class BidParams < ApplicationParams
    params do
      required(:amount).filled(:float)
    end
  end
end
