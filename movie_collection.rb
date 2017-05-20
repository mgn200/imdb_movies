require 'csv'
require 'ostruct'
require 'date'
require 'pry'
require 'date'

class MovieCollection
  KEYS = %w[link title year country detailed_year genre duration rating director actors]
  attr_reader :all

  def initialize(file)
    @all = parse_file(file)
  end

  def sort_by(field)
    if field == :director
      puts @all.sort_by{ |x| x.director.split(' ').last }
    else
      puts @all.sort_by { |x| x.send field }.map(&:to_s)
    end
  end

  def filter(hash)
    key = hash.keys.first
    value = hash.values.first
    puts @all.select {|x| (x.send(key)).include? value}
  end

  def stats(field)
    case field
    when :actors
      actors = @all.map { |x| x.actors.first.split "," }
              .flatten
              .group_by(&:itself)
      puts actors.each {|k, v| actors[k] = v.length }
    when :month
      month = @all.reject { |x| x.detailed_year.length <= 4 }
                  .map { |x| Date.strptime(x.detailed_year, '%Y-%m').mon }
                  .group_by { |x| Date::MONTHNAMES[x] }
      puts month.each { |k, v| month[k] = v.length }
    else
      movies = @all.map(&field).group_by(&:itself)
      puts movies.each {|k, v| movies[k] = v.length }
    end
  end

  private

  def parse_file(file)
    CSV.foreach(file, { col_sep: '|', headers: KEYS }).map { |row| Movie.new(row.to_h) }
  end
end

