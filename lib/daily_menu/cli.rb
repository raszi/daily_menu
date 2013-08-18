require 'colorize'

module DailyMenu
  class ColoredFormatter
    def self.print(restaurant, entry)
      puts restaurant.name.green
      puts entry.content
      puts entry.time.to_s.yellow
      puts ''
    end
  end

  class MarkdownFormatter
    def self.print(restaurant, entry)
      puts "# #{restaurant.name}"
      puts ''
      puts entry.content
      puts ''
      puts "*#{entry.time}*"
      puts ''
      puts '- - -'
      puts ''
    end
  end

  class CLI
    RC_FILE = File.expand_path('.daily_menurc', ENV['HOME']).freeze

    def self.start(arguments)
      location = arguments.empty? ? read_rc : arguments.first
      print(DailyMenu.menus_for(location))
    end

    def self.print(menus)
      formatter = STDOUT.tty? ? ColoredFormatter : MarkdownFormatter

      menus.each do |restaurant, entry|
        formatter.print(restaurant, entry)
      end
    end
    private_class_method :print

    def self.read_rc
      raise 'Unable to read the config file' unless DailyMenu.file_accessible?(RC_FILE)

      File.new(RC_FILE).read.chomp
    end
    private_class_method :read_rc

  end

end
