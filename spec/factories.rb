require 'date'
movie_collection = MovieCollection.new('movies_for_spec.txt')
FactoryGirl.define do
  factory :movie_collection do

  end

  factory :movie do
    list { movie_collection }
    movie_info { { title: 'Movie',
                   link: 'test',
                   year: 1944,
                   country: 'USA',
                   date: '1111-11-11',
                   genre: 'Comedy',
                   duration: 188,
                   rating: '9',
                   director: 'Paul Fear',
                   actors: 'Bob, Jack'
               } }
    initialize_with { new(list, movie_info) }
  end

  factory :ancient_movie, class: AncientMovie, parent: :movie do
    year 1944
    title 'AncientMovie'
  end

  factory :modern_movie, class: ModernMovie, parent: :movie do
    year 1987
    title 'ModernMovie'
  end

  factory :new_movie, class: NewMovie, parent: :movie do
    year 2004
    title 'NewMovie'
  end

  factory :classic_movie, class: ClassicMovie, parent: :movie do
    year 1956
    title 'ClassicMovie'
  end

  factory :netflix, class: Netflix, parent: :movie_collection do
    initialize_with { new(movie_collection) }
  end
end
