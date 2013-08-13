module DailyMenu::Filters
  class Hungarian
    extend Forwardable
    def_delegator :@filter, :matches?

    def initialize
      @filter = Regexp.new(/\b(?:menü|ebéd|leves)/i)
    end
  end
end
