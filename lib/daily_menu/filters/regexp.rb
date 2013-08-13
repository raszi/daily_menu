module DailyMenu::Filters
  class Regexp
    def initialize(regexp)
      @regexp = regexp
    end

    def matches?(text)
      @regexp.match(text.content)
    end
  end
end
