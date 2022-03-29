# frozen_string_literal: true

require './src/game'

game = Game.new(ARGV[0])
p game.score
