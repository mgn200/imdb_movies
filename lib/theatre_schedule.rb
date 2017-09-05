module MovieProduction
  module TheatreSchedule
    # Содержит дефолтное расписание для театров
    # Содержит методы для обработки расписания театра
    DEFAULT_SCHEDULE = { ("06:00".."12:00") => { filters: { period: :ancient },
                                                 daytime: :morning,
                                                 price: 3,
                                                 hall: [:red] },
                         ("12:00".."18:00") => { filters: { genre: %w[Comedy Adventure] },
                                                 daytime: :afternoon,
                                                 price: 5,
                                                 hall: [:green] },
                         ("18:00".."24:00") => { filters: { genre: %w[Drama Horror] },
                                                 daytime: :evening,
                                                 price: 10,
                                                 hall: [:blue] },
                         ("00:00".."06:00") => { :session_break => true }
                       }

    DEFAULT_HALLS = { :red => { title: 'Красный зал', places: 100 },
                      :blue => { title: 'Синий зал', places: 50 },
                      :green => { title: 'Зелёный зал (deluxe)', places: 12 } }


    def gather_movies(schedule)
      # binding.pry
      #
      #lters = 
      # { "06:00 - 12:00" => { desc: Comedy, Adventure, movies: ['Abc', 'Has'] } }
    end

  end
end
