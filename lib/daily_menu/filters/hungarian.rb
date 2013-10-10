module DailyMenu::Filters
  class Hungarian
    extend Forwardable
    def_delegator :@filter, :matches?

    def initialize
      @filter = DailyMenu::Filters::Regexp.new(/\b(?:menü|ebéd|leves|\d+.-)/i)
    end
  end
end
