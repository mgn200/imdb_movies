require 'date'
require 'csv'
require 'ostruct'
require 'pry'
require_relative 'movie.rb'

default_file = "movies.txt"
file = ARGV.first || default_file
abort('No such file') unless File.exist? file
puts "Using default file" if file == default_file

movies = MovieCollection.new(file)

begin
movies.all.first.has_genre? 'Test'
rescue StandardError
puts "No such genre"
end
