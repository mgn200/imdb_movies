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
movies.stats :director
=begin
movies = CSV.foreach(file, { col_sep: '|', headers: KEYS }).map { |row| OpenStruct.new(row.to_h) }

def show_movies(movies)
  movies.each do |m|
    puts "#{m.title} (#{m.detailed_year}; #{m.genre}) - #{m.duration}"
  end
end

# 5 самых длинных фильмов.
movies_by_duration = movies.sort_by { |x| -x.duration.to_i }.take 5
show_movies movies_by_duration
puts "******"

# 10 комедий(первые по дате выхода).
comedy_movies = movies.select { |x| x.genre.include? 'Comedy' }.sort_by { |x| x.detailed_year }.take 10
show_movies comedy_movies
puts "******"

# Cписок всех режиссёров по алфавиту(без повторов), отсортировать по фамили
puts movies.map(&:director).uniq.sort_by{ |x| x.split(' ').last }
puts "******"

# кол-во фильмов, снятых не в США
puts movies.count { |x| (x.country != 'USA') }

# статистика по месяцам
a = movies.reject { |x| x.detailed_year.length <= 4 }
          .map { |x| Date.strptime(x.detailed_year, '%Y-%m').mon }
          .group_by { |x| Date::MONTHNAMES[x] }
          .each { |k, v| puts "#{k}: #{v.length} movies" }
=end
