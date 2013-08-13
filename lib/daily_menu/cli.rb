require 'yaml'
require 'awesome_print'

module DailyMenu
  class CLI
    RC_FILE = File.expand_path('.daily_menurc', ENV['HOME']).freeze

    def self.start(arguments)
      location = arguments.empty? ? read_rc : arguments.first
      ap fetch(location)
    end

    def self.fetch(location)
      menus = restaurants_for_location(location).map do |restaurant|
        [restaurant.name, restaurant.menu]
      end

      Hash[menus]
    end
    private_class_method :fetch

    def self.read_rc
      raise 'Unable to read the config file' unless file_accessible?(RC_FILE)

      File.new(RC_FILE).read.chomp
    end
    private_class_method :read_rc

    def self.restaurants_for_location(location)
      configs_for_location(location).map { |config| Restaurant.from_hash(config) }
    end
    private_class_method :restaurants_for_location

    def self.configs_for_location(location)
      config_file = ROOT.join('configs', "#{location}.yml")
      raise %(No configuration found for: "#{location}") unless file_accessible?(config_file)

      YAML.load_file(config_file)
    end
    private_class_method :configs_for_location

    def self.file_accessible?(file)
      File.exists?(file) && File.readable?(file)
    end
    private_class_method :file_accessible?
  end

end
