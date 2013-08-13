require 'spec_helper'
require 'koala'

module Koala::Facebook
  describe API do
    let(:user) { 'Koleves' }
    let(:token) { DailyMenu::OAUTH_TOKEN }
    let(:api) { described_class.new(token) }

    it 'should get the feed as an Array' do
      pending('OAuth token is not provided') if token.nil?

      VCR.use_cassette('feed') do
        expect(api.get_connections(user, 'feed')).to be_an(Array)
      end
    end

    describe '.get_object' do
      it 'should contain the id' do
        pending('OAuth token is not provided') if token.nil?

        VCR.use_cassette('object') do
          expect(api.get_object('Koleves').keys).to include('id')
        end
      end
    end

    context('an item from the feed') do
      let(:item) do
        VCR.use_cassette('feed') do
          api.get_connections(user, 'feed').first
        end
      end

      it 'should be a Hash' do
        pending('OAuth token is not provided') if token.nil?

        expect(item).to be_a(Hash)
      end

      it 'should have the correct keys' do
        pending('OAuth token is not provided') if token.nil?

        expect(item.keys).to include(*%w(id from type created_time))
      end

      it 'the from field should contain the id' do
        pending('OAuth token is not provided') if token.nil?

        expect(item['from'].keys).to include('id')
      end

    end
  end
end
