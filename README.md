# ImdbPlayfield

ImdbPlayfield is a Ruby study project, built with the mentoring help of mkdev.me team member.
It covers everything a good junior-level developer should know about Ruby. It uses imdb top 250 as a playground
for Ruby features and design patterns.

It implements:
 - Parsing text files, creating objects from data
 - Sorting and filtering collections, data manipulation(with movies)
 - Playing around with classes relationships(movies, theatres and useful modules.
 - Test Driven Development
 - DSL
 - Basic objects design with composition and inheritance
 - Scrapping with Nokogiri
 - Working with TMDB.com API
 - Using HAML with bootstrap template to create html page of top 250 movies
 - Learning correct documentation and project structure

## Instal

Install gem and don't forget to require it
```ruby
gem install imdb_playfield
```
```ruby
require 'imdb_playfield'
```

## Usage

### Basic usage

You have several options to play around:
Filtering and sorting movies from movies.txt collection:
```ruby
imdb_movies = ImdbPlayfield::MovieCollection.new
imdb_movies.filter(country: 'USA')                   # returns array of movies made in USA
imdb_movies.filter(rating: 8.2)                      # returns array of movies with rating of 8.2
imdb_movies.sample(10).has_genre?('Comedy')          # returns true of false if any comedy movie present in array
imdb_movie_.filter(period: :ancient)                 # returns all movies that were made before 1945
```

Creating online and offline movie theatres:
```ruby
netflix = ImdbPlayfield::Netflix.new                             
theatre = ImdbPlayfield::Theatre.new

netflix.cash                                          # shows how much cash Netflix has
netflix.pay                                           # puts cash to balance
netflix.how_much 'The Terminator'                     # returns price for movie in dollars
netflix.show 'The Terminator'                         # "shows" movie, withdraw it's price from balance

theatre.when? 'The Terminator'                        # returns time when movie will be shown
theatre.buy_ticket('The Terminator', hall: :red)      # buy ticket and withdraw it's price from balance
```
Creating complex filters for Netflix:
```ruby
netflix = ImdbPlayfield::Netflix.new
netflix.define_filter(:new_sci_fi) { !movie.title.include?('Terminator') && movie.genre.include?('Action') && movie.year > 2003 }
# create and save new_sci_file filter
netflix.show(new_sci_fi: true)                        # returns filtered array of movies
```

Creating schedule for movie theatre with DSL:
```ruby
theatre = ImdbPlayfield::Theater.new do                              # creates a Theatre with given schedule
    hall :red, title: 'Красный зал', places: 100
    hall :blue, title: 'Синий зал', places: 50
    hall :green, title: 'Зелёный зал (deluxe)', places: 12

    period '09:00'..'11:00' do
      description 'Morning session'
      filters genre: 'Comedy', year: 1900..1980

    end

    period '11:00'..'16:00' do
      description 'Noon non-old dramas'
      filters genre: 'Drama', exclude_period: :ancient
    end
  end

theatre.info                                        # prints current schedule
```

Create html page of movies from Netflix
```ruby
netflix = ImdbPlayfield::Netflix.new
netflix.build_html                                  # creates and index.html file in data/views/
```

### Full actions for every object
MovieCollection is the movies container from movies.txt file (prepared list of top 250 imdb movies)
It stores collection methods and creates Movies objects based on movie attributes.

Default movie attributes are: link, title, year, country, date, genre, duration, rating, director, actors.

MovieCollection methods:
```ruby
movies_collection = ImdbPlayfield::MovieCollection.new

# Array of every parsed movie from movies.txt
movies_collection.all   

# Sort movies array by given attribute name
movies_collection.sort_by(:director)

# Filters movies collection with hash parameters
# Params are default movie attributes
# You can also use exclude_attribute filter
movies_collection.filter(period: :new, exclude_country: 'USA', genre: 'Action')

# Pick one more from given array
# The more rating movie has, the more "weight" it has in comparison to other
# Higher rated movies will be a bit more likely to be selected
movies_collection.pick_movie movies_collection.sample(10)

# Counts attribute values and returns a hash. For example:
# { 'Comedy' => 28, 'Action' => 15, 'Drama' => 89, ... }
movies_collection.stats(:genre)
# or
movies_collection.stats(:director)
```

Movie is an abstract class for every movie parsed and created from movies.txt
It has 4 different types, based on film year: AncientMovie, ModernMovie, NewMovie, ClassicMovie.
Every movie is created when MovieCollection is initialized.

```ruby
movie = ImdbPlayfield::MovieCollection.new.all.first

movie.to_s        # Returns a string with basic movie info
movie.month       # "January"
movie.price       # 10 (in dollars)
```

Netflix is a representation of online movie theater.

```ruby
netflix = ImdbPlayfield::Netflix.new

# Balance is 0 dollars by default
# You can put money and use it to pay for movies
netflix.pay 10
netflix.balance       # 10

# You can order movies, if you have enough money
# It will use #pick_movie from MovieCollection
netflix.show(year: 2000, genre: 'Drama')

# You can also use more advanced filtering and save your filters
netflix.show { |movie| !movie.title.include?('Terminator') && movie.genre.include?('Action') && movie.year > 2003 }
netflix.define_filter(:new_sci_fi) { movie.period: :new, movie.genre: 'Sci-Fi' }
netflix.show(new_sci_fi: true)

# Returns the price for the given movie title
# netflix.show will raise 'Insufficient funds' ArgumentError, if you don't have enough money on balance
netflix.how_much? 'The Terminator'        # 10

# Start builds an html page
# Make sure you run bin/fetch_imdb and bin/fetch_tmdb before build_html
# as the method uses additional data from YML files generated by these external requests
# (they are covered in IMDBScrapper and TMDBApi classes)

netflix.build_html        # creates index.html in data/views

# Some DSL for more convenient filters
netflix.by_genre.comedy # returns all the comedies
netflix.by_country.usa # returns all movies made in USA
```

Theatre - a representation of real world theater.

```ruby
theater = ImdbPlayfield::Theatre.new

# USE DSL to build your own schedule
# It uses default one otherwise. The time holes(i.e night time) will be considered as session break
# If your schedule periods intersect with each other or have holes between first and last of them - an error will be range_in_seconds

theatre = ImdbPlayfield::Theater.new do                              
    hall :red, title: 'Красный зал', places: 100
    hall :blue, title: 'Синий зал', places: 50
    hall :green, title: 'Зелёный зал (deluxe)', places: 12

    period '09:00'..'11:00' do
      description 'Morning session'
      filters genre: 'Comedy', year: 1900..1980
      price 10
      hall :red, :blue
    end

    period '11:00'..'16:00' do
      description 'Special'
      title 'The Terminator'
      price 50
      hall :green
    end

    period '16:00'..'20:00' do
      description 'Evening session'
      filters genre: ['Action', 'Drama'], year: 2007..Time.now.year
      price 20
      hall :red, :blue
    end

    period '19:00'..'22:00' do
      description 'Evening session for movie fans'
      filters year: 1900..1945, exclude_country: 'USA'
      price 30
      hall :green
    end
  end

# Convenietnly pronts schedule info
theatre.info

# Buy ticket for the given movie. Hall must be specified if movie can be seen in different halls.
theatre.buy_ticket('The Terminator', :red)

# Shows number of cash in the current theatre
theatre.cash

# Returns periods if time, when the given movie is shown
# Puts a message, when movie is not shown in the current schedule
# or is not found in the MovieCollection.all
theatre.when? 'The Terminator'

# Show all halls
theatre.halls
```

IMDBScrapper and TMDBApi are "data miners" that collect data needed for netflix.build_html method.
It uses this data in haml and bootstrap template file in data/views/index.haml.
Info is stored in YML files at data/movies_imdb_info.yml and data/movies_tmdb_info.yml.
You can use HamlBuilder outside of Netflix, to render html when you need it.

Run rake tasks to create yml files: `rake fetch_imdb` and `rake fetch_tmdb`
After that you can:
```ruby
ImdbPlayfield::HamlBuilder.new.build_html     # creates data/views/index.html
```

## Supported Ruby versions

This app supports Ruby >= 2.3.0 
