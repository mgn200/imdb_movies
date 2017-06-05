# AMovie Categories
FactoryGirl.define do
  factory :movie do
    list 'abc'
    movie_info {{actors: "a,b,c", genre: 'Comedy,Drama'}}
    initialize_with { new(list, movie_info) }
  end

  factory :ancient_movie do
    movie_info { {title: 'AncientMovie', year: 1944} }
    initialize_with { new(movie_info)}
  end

  factory :modern_movie do
    movie_info { {title: 'ModernMovie', year: 1999} }
    initialize_with { new(movie_info)}
  end

  factory :new_movie do
    movie_info { {title: 'NewMovie', year: 2012} }
    initialize_with { new(movie_info)}
  end

  factory :classic_movie do
    movie_info { {title: 'ClassicMovie', year: 1978} }
    initialize_with { new(movie_info)}
  end
end
