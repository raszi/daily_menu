require 'spec_helper'

module DailyMenu
  describe Scrapers::Facebook do
    From = Struct.new(:id)
    FeedItem = Struct.new(:from, :message, :created_time)

    def random_time
      Time.at(rand(Time.now.to_i)).utc.to_datetime
    end

    let(:user) { 'Koleves' }
    let(:user_id) { '185479434829378' }
    let(:scraper) { described_class.new(user) }

    let(:greeting_text) { 'This is just a greeting' }
    let(:greeting_time) { random_time }

    let(:daily_menu_text) { 'Our daily menu is' }
    let(:daily_menu_time) { random_time }

    let(:other_user_time) { random_time }
    let(:other_user) { From.new(0) }

    let(:feed_items) do
      [
        FeedItem.new(From.new(user_id), greeting_text, greeting_time.rfc3339),
        FeedItem.new(From.new(user_id), daily_menu_text, daily_menu_time.rfc3339),
        FeedItem.new(other_user, daily_menu_text, other_user_time.rfc3339)
      ]
    end

    describe '#entries' do
      before do
        Koala::Facebook::API.any_instance.stub(:get_object) { { 'id' => user_id } }
      end

      context 'when an error occurs' do
        it 'should raise RuntimeError' do
          Koala::Facebook::API.any_instance.stub(:get_connections) { raise Koala::Facebook::ClientError.new(nil, nil) }

          expect { scraper.entries }.to raise_error(RuntimeError)
        end
      end

      context 'when there are no errors' do
        before do
          Koala::Facebook::API.any_instance.stub(:get_connections) { feed_items }
        end

        it 'should create Entry items' do
          entries = scraper.entries

          expect(entries.all? { |entry| entry.is_a?(Entry) }).to be_true
        end

        it 'should fetch the entries of the specified user from Facebook' do
          entries = scraper.entries

          expect(entries).to have(2).entries
          expect(entries).to include(Entry.new(greeting_text, greeting_time), Entry.new(daily_menu_text, daily_menu_time))
        end
      end
    end
  end
end
