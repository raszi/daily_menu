require 'daily_menu/version'
require 'yaml'

module DailyMenu
  OAUTH_TOKEN = ENV['FACEBOOK_OAUTH_TOKEN'].freeze
  ROOT = Pathname.new(File.expand_path('../..', __FILE__)).freeze
  CONFIG_DIR = ROOT.join('configs').freeze

  def self.menus_for(location)
    restaurants = DailyMenu.restaurants_for(location)
    
    menus = []

    threads = restaurants.map do |restaurant|
      thread = Thread.new do
        menus << [restaurant, restaurant.menu]
      end
    end

    threads.map(&:join)

    menus
  end

  def self.restaurants_for(location)
    raise ArgumentError, 'Location needed' unless location

    configs = config_for(location)
    configs.map { |config| DailyMenu::Restaurant.from_hash(config) }
  end

  def self.config_for(location)
    config_file = CONFIG_DIR.join("#{location}.yml").to_s
    raise %(No configuration found for: "#{location}") unless file_accessible?(config_file)

    YAML.load_file(config_file)
  end
  private_class_method :config_for

  def self.file_accessible?(file)
    File.exists?(file) && File.readable?(file)
  end
end

require 'daily_menu/entry'
require 'daily_menu/filters'
require 'daily_menu/scrapers'
require 'daily_menu/restaurant'
require 'daily_menu/cli'
