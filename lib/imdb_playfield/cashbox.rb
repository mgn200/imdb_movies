module ImdbPlayfield
  # Module incapsulating working with cash box (storing money, cash balance, incassation).
  # Used by {Netflix} and {Theatre}
  module Cashbox
    I18n.enforce_available_locales = false

    # Amount of cash in Theater. Default is zero.
    # @return [Money]
    #   Object with current cash in theatre.
    def cash
      @cash ||= Money.new(0)
    end

    # Puts money to cashbox.
    # @param price [Integer] money amount
    # @return [Money] updated cash value after putting money to cashbox
    def store_cash(price)
      @cash = cash + Money.new(price * 100)
    end

    # Empties cashbox by moving money to "Bank".
    # @param who [Object] any object can be given
    # @return [String] success message if param is 'Bank'
    def take(who)
      raise ArgumentError, 'Вызываю полицию' unless who == 'Bank'
      @cash = Money.new(0)
      "Проведена инкассация"
    end
  end
end
