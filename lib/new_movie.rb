require_relative 'movie'
module MovieProduction
  class NewMovie < MovieProduction::Movie
    def to_s
      years_passed = Date.today.year - @year
      "#{@title} - новинка, вышло #{years_passed} лет назад!"
    end
  end
end
