require 'csv'
require 'date'
require 'money'
require_relative 'lib/coercions'
require_relative 'lib/movie'
require_relative 'lib/movie_collection'
require_relative 'lib/cashbox'
require_relative 'lib/movies_dsl'
require_relative 'lib/netflix'
require_relative 'lib/netflix_reference'
require_relative 'lib/theatre_builder'
require_relative 'lib/theatre'
require_relative 'lib/ancient_movie'
require_relative 'lib/classic_movie'
require_relative 'lib/modern_movie'
require_relative 'lib/new_movie'
# netflix = MovieProduction::Netflix.new
# netflix.show { |movie| !movie.title.include?('Terminator') && movie.genre.include?('Action') && movie.year > 2003}
# netflix.define_filter(:test) { |movie| movie.director != 'David Fincher' && movie.year > 1999 }
# puts movies.stats :month
# puts movies.filter(genre: 'Comedy', year: 2011)
# puts movies.filter(actors: /Bob/)
# puts movies.filter(period: 'Ancient').count
# movies.sort_by :year
# movies.all.first.has_genre? ['Drama', 'Adventure']
# movies.all.first.has_genre? 'Dramdsa'
theatre =
  MovieProduction::Theatre.new do
    # Классу передается блок
    # Из блока создаются атрибуты класса
    # методо hall принимает аргументы и записывает их в константы
    # остальные принимают блок
    hall :red, title: 'Красный зал', places: 100
    hall :blue, title: 'Синий зал', places: 50
    hall :green, title: 'Зелёный зал (deluxe)', places: 12

    period '09:00'..'11:00' do
      description 'Утренний сеанс'
      filters genre: 'Comedy', year: 1900..1980
      price 10
      hall :red, :blue
    end

    period '11:00'..'16:00' do
      description 'Спецпоказ'
      title 'The Terminator'
      price 50
      hall :green
    end

    period '16:00'..'20:00' do
      description 'Вечерний сеанс'
      filters genre: ['Action', 'Drama'], year: 2007..Time.now.year
      price 20
      hall :red, :blue
    end

    period '19:00'..'22:00' do
      description 'Вечерний сеанс для киноманов'
      filters year: 1900..1945, exclude_country: 'USA'
      price 30
      hall :green
    end
  end
binding.pry
