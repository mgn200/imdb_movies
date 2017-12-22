# ImdbPlayfield

ImdbPlayfield is a Ruby study project, built with the mentoring help of mkdev.me team member.
It covers everything a good junior-level developer should know about Ruby. It uses imdb top 250 movies as a playground
for Ruby features and patterns.

ImdbPlayfield implements:
 - Parsing text files, creating objects from data;
 - Sorting and filtering collections, data manipulation(movies);
 - Playing around with classes and their relationships;
 - Test Driven Development;
 - DSL;
 - Basic app designing. Composition and inheritance patterns;
 - Scrapping with Nokogiri;
 - Working with tmdb.com API;
 - Using HAML and bootstrap template to create html page of top 250 movies;
 - Learning correct documentation and project structure, wrapping code in gem.

## Install

Install gem and don't forget to require it
```ruby
gem install imdb_playfield
```
```ruby
require 'imdb_playfield'
```

You can also use some commands from CLI, сalling imdb and tmdb data miners and folder/files builders.
Check more at [link](#Netflix), [link](#TMDBApi), [link](#IMDBScrapper)

## Usage

Main entities and their functionality.

### <a name="Netflix"></a> Netflix

Netflix is a representation of online movie theater.

```ruby
netflix = ImdbPlayfield::Netflix.new

# Balance is 0 dollars by default
# You can put money and use it to pay for movies
netflix.pay 10
netflix.balance       # 10

# You can order movies, if you have enough money, by providing desired movie parameters
netflix.show(year: 2000, genre: 'Drama')

# You can also use more advanced filtering and save your filters for future use
netflix.show { |movie| !movie.title.include?('Terminator') && movie.genre.include?('Action') && movie.year > 2003 }
netflix.define_filter(:new_sci_fi) { |movie| movie.period == :new, movie.genre == 'Sci-Fi' }
netflix.show(new_sci_fi: true)

# Additional parameters of user filters:
netflix.define_filter(:new_sci_fi) { |movie, year| movie.year > year && ... }
netflix.show(new_sci_fi: 2010)
# Build custom filter based on another:
netflix.define_filter(:newest_sci_fi, from: :new_sci_fi, arg: 2014)

# Returns price for the given movie title
# netflix.show will raise 'Insufficient funds' error if you don't have enough money on balance
netflix.how_much? 'The Terminator'        # 10

# Some DSL for more convenient filters
netflix.by_genre.comedy # returns all the comedies
netflix.by_country.usa # returns all movies made in USA
```

You can also call #pay and #show in you CLI instead of code:
imdb_playfield netflix pay 25
imdb_playfield netflix show genre:Comedy year:2002

**Netflix#build_html** method will create an index.html file with
movies info from movie collection. It uses HamlBuilder class
that handles all the work.

Bear in mind, by default ImdbPlayfield gem is packed with two data files
about movies additional information: "movies_imdb_info.yml" and
"movies_tmdb_info.yml", stored in "imdb_playfield/data/".

Both of these files were created using TMDBApi.run and IMDBScrapper.run methods.
Additional data in these files is used for rendering index.html page.
If TMDBApi.run or IMDBScrapper.run called by user, it will create new
data files and use them instead.

*But first*, you need to build required files and folders.
For more information on that please check:
[TMDBApi](#TMDBApi) [IMDBScrapper](#IMDBScrapper)

```ruby
netflix.build_html # Build index.html and puts it in data/views
                   # file contain representation of every movie in collection
```

### Theatre

Theatre is a representation of real world theater.

```ruby
theater = ImdbPlayfield::Theatre.new

# Use DSL to build your own schedule, it uses default one otherwise.
# If your schedule periods intersect with each other or have holes between
# first and last of them, an error will be raised.

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

# Prints schedule for user
theatre.info

# "Buys" ticket for the given movie.
# Hall must be specified if movie is shown in two or more halls.
theatre.buy_ticket('The Terminator', :red)

# Shows number of cash in theater.
theatre.cash

# Returns periods of time when the given movie is shown.
theatre.when? 'The Terminator'

# Shows all halls in theater.
theatre.halls
```

#### MovieCollection

MovieCollection is a base class that parses movie.txt or similar
file provided by user. It creates collection of movies and provides
sorting and filtering methods for them.

```ruby
# Creates movie collection from file specified as argument.
# By default uses movies.txt packed in gem.
# Default movies.txt is top 250 movies from imdb.
movie_collection = ImdbPlayfield::MovieCollection.new()

# Basic example:
imdb_movies.filter(country: 'USA')            # returns array of movies made in USA
imdb_movies.filter(rating: 8.2)               # returns array of movies with rating of 8.2
imdb_movies.sample(10).has_genre?('Comedy')   # returns true of false if any comedy movie present in array

# Array of every parsed movie from movies.txt or user file.
movies_collection.all   # [ModernMovie, AncientMovie, ClassicMovie, NewMovie]

# Sort movies array by given attribute name.
movies_collection.sort_by(:director)

# Filters movie collection based on parameters(movie attributes) provided in hash.
# You can also use exclude_#{attribute} parameter.
movies_collection.filter(period: :new, exclude_country: 'USA', genre: 'Action')

# Random weighted movie pick from array.
# Higher rated movies will be a bit more likely to be selected.
movies_collection.pick_movie movies_collection.sample(10)

# Count every attribute values and return a hash with stats. For example:
movies_collection.stats(:genre)      # { 'Comedy' => 28,
                                     #   'Action' => 15,
                                     #   'Drama' => 89, ... }
# or
movies_collection.stats(:director)
```

#### Movie

Movie is an abstract class for every movie parsed and created from
movies.txt or user file. It inherits to 4 movie classes, based on film year:
AncientMovie, ModernMovie, NewMovie, ClassicMovie.

Movies are created when MovieCollection.new is called.

```ruby
movie = ImdbPlayfield::MovieCollection.new.all.first

movie.to_s        # Returns a string with basic movie info
movie.month       # "January"
movie.price       # 10 (in dollars)
```

#### HamlBuilder

This class builds index.html page and saves it in your_current_folder/data/views.
It is used in Netflix#build_html method, but can be accessed straightforward.

```ruby
ImdbPlayfield::HamlBuilder.new.build_html
```

### <a name="TMDBApi"></a> TMDBApi

Class that handles requests to tmdb.com API and storing data in local yml file.

It fetches additional movie data provided by tmdb.com and is used by HamlBuilder#build_html.
By default, ImdbPlayfield gem is already packed with movies_tmdb_info.yml
and additional movies info. But user can manually call TMDBApi.run to update
information and create local movies_tmdb_info.yml file.
HamlBuilder will use that file instead.

**NOTE**
Before calling TMDBApi and updating movie info, you need to prepare folders
and empty files: movies_tmdb_info.yml and config.yml(which will store you tmdb.com API key).
If you don't have it, you need to register at tmdb.com and get the key.

You can do all of this in terminal, or in your code:
**CLI**
imdb_playfield create_config      => creates config.yml in current directory, don't forget to insert API key in it.
imdb_playfield scaffold_new       => created data/views and all empty files that are needed for data miners
                                  => movies_tmdb_info.yml for TMDB and movies_imdb_info.yml for IMDB

Ruby code, does same as above:
```ruby
ImdbPlayfield.create_config
ImdbPlayfield.create_data_files
```

After that you can call TMDBApi runner, that will save information to
your_current_folder/data/movies_tmdb_info.yml
**CLi**
imdb_playfield fetch_tmdb       => data/movies_tmdb_info.yml

Ruby
```ruby
ImdbPlayfield::TMDBAPi.run      #  data/movies_tmdb_info.yml
```
### <a name="IMDBScrapper"></a> IDMBScrapper

Is a imdb.com web scrapper. It opens imdb page for every movie in a given array of movies
based on their imdb id, and fetches additional information about movie budget.
Default array of movies is MovieCollection.all

It functions just as ImdbPlayfield::TMDBApi in terms of data storing and user usage.
Default data file is movies_imdb_info.yml. If you need to update information,
you can call IMDBScrapper.run that will overwrite yml file.

You also need folders and yml file created beforehand(not config.yml though)

Check [link][#TMDBApi] last section for easy building of folders and file.

To run scrapper:
**CLI**
imdb_playfield fetch_imdb                => data/movies_imdb_info.yml

Ruby
```ruby                                  
ImdbPlayfield::IMDBScrapper.run           # data/movies_imdb_info.yml
```

## Supported Ruby versions

This app supports Ruby >= 2.3.0

####

Thanks for checking my ruby project. It was fun building it.
