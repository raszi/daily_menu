require 'daily_menu/version'

module DailyMenu
  OAUTH_TOKEN = ENV['FACEBOOK_OAUTH_TOKEN'].freeze
  ROOT = Pathname.new(File.expand_path('../..', __FILE__)).freeze
  CONFIG_DIR = ROOT.join('configs').freeze
end

require 'daily_menu/entry'
require 'daily_menu/filters'
require 'daily_menu/scrapers'
require 'daily_menu/restaurant'
require 'daily_menu/cli'
