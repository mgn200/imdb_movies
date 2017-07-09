require 'pry'
require_relative './movie.rb'
module Movieproduction
  class AncientMovie < Movieproduction::Movie
    PRICE = 1

    def to_s
      "#{@title} - старый фильм(#{@year} год)"
    end
  end
end
