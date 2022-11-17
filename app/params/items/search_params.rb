# frozen_string_literal: true

module Items
  class SearchParams < ApplicationParams
    params do
      required(:term).filled(:string)
    end
  end
end
