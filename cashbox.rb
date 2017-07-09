module MovieProduction

  module Cashbox
    def cash
      @cash ||= Money.new(0)
    end

    def store_cash(price)
      @cash = cash + Money.new(price*100)
    end

    def take(who)
      raise ArgumentError, 'Вызываю полицию' unless who == 'Bank'
      @cash = Money.new(0)
      "Проведена инкассация"
    end
  end
end
