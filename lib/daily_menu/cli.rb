require 'awesome_print'

module DailyMenu
  class CLI
    RC_FILE = File.expand_path('.daily_menurc', ENV['HOME']).freeze

    def self.start(arguments)
      location = arguments.empty? ? read_rc : arguments.first
      ap fetch(location)
    end

    def self.fetch(location)
      menus = DailyMenu.menus_for(location)
      Hash[menus]
    end
    private_class_method :fetch

    def self.read_rc
      raise 'Unable to read the config file' unless DailyMenu.file_accessible?(RC_FILE)

      File.new(RC_FILE).read.chomp
    end
    private_class_method :read_rc
  end

end
