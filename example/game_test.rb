require_relative '../lib/connected_four.rb'

puts 'Welcome to the test game!'
alk = ConnectedFour::Player.new(color: "\u25CD", name: 'alk')
mervin = ConnectedFour::Player.new(color: "\u25CF", name: 'mervin')
players = [alk, mervin]
ConnectedFour::Game.new(players).play
