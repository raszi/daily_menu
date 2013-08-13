require 'koala'
require 'time'

module DailyMenu
  class Scrapers::Facebook

    def initialize(user)
      @user = user
      @api = Koala::Facebook::API.new(DailyMenu::OAUTH_TOKEN)
    end

    def entries
      @api
        .get_connections(user_id, 'feed')
        .select { |feed_item| feed_item['from']['id'] == user_id && feed_item['message'] }
        .map { |entry| Entry.new(entry['message'], parse_time(entry['created_time'])) }
    end

    def user_id
      @user_id ||= @api.get_object(@user)['id']
    end
    private :user_id

    def parse_time(time)
      DateTime.parse(time).new_offset(0)
    end
    private :parse_time

  end
end
