module DailyMenu
  class Restaurant
    attr_reader :name

    def initialize(name, scraper, filter)
      @name, @scraper, @filter = name, scraper, filter
    end

    def menu
      @scraper.entries.select { |entry| @filter.matches?(entry) }.sort_by(&:time).last
    end

    def self.from_hash(hash)
      scraper = create_instance_from('Scrapers', hash[:scraper])
      filter = create_instance_from('Filters', hash[:filter])

      new(hash[:name], scraper, filter)
    end

    def self.create_instance_from(namespace, config)
      class_to_instantiate = Object.const_get("DailyMenu::#{namespace}::#{config[:class].capitalize}")
      if config[:params]
        class_to_instantiate.new(*config[:params])
      else
        class_to_instantiate.new
      end
    end
    private_class_method :create_instance_from

  end
end
