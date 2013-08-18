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
        .map { |entry| Entry.new(strip_content(entry['message']), parse_time(entry['created_time'])) }
    rescue Koala::Facebook::ClientError => e
      error = RuntimeError.new(e.message)
      error.set_backtrace(e.backtrace)
      raise error
    end

    def user_id
      @user_id ||= @api.get_object(@user)['id']
    end
    private :user_id

    def parse_time(time)
      DateTime.parse(time).new_offset(0)
    end
    private :parse_time

    def strip_content(message)
      message.gsub("\r\n", "\n")
    end
    private :strip_content

  end
end
