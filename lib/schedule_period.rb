require 'ostruct'
module MovieProduction
  class SchedulePeriod
    include Enumerable
    include Virtus.model

    # можно сюда же засунуть и сам рейнжд "00:00".."00:00"
    # но тогда нельзя напрямую обращаться к рейнджу @schedule[00:00..00.00]
    # только вытягивать его через find?
    attribute :filters
    attribute :daytime
    attribute :price
    attribute :hall
    attribute :description
    attribute :session_break, Boolean,:default => false
  end
end
