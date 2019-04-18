# frozen_string_literal: true

require 'json'
require 'sequel'

module CheatChat
  # Models a hand
  class Hand < Sequel::Model
    many_to_one :game

    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'hand',
            attributes: {
              id: id,
              values: values
            }
          },
          included: {
            game: game
          }
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end