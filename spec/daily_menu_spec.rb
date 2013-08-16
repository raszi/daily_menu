require 'spec_helper'

describe DailyMenu do
  let(:location) { 'City/Area' }

  describe 'ROOT' do
    it 'should return the root path of the gem' do
      expected_path = File.expand_path('..', File.dirname(__FILE__))
      expect(described_class::ROOT.to_s).to eq(expected_path)
    end
  end

  describe 'VERSION' do
    it 'should not be nil' do
      expect(described_class::VERSION).to_not be_nil
    end
  end

  describe '.restaurants_for' do
    it 'should raise an error when called with nil' do
      expect { described_class.restaurants_for(nil) }.to raise_error(ArgumentError)
    end

    it 'should raise an error when the config file not found or not readable' do
      expect { described_class.restaurants_for(location) }.to raise_error
    end

    it 'should read the configuration file' do
      described_class.stub(:file_accessible?) { true }
      YAML.stub(:load_file) { [] }

      described_class.restaurants_for(location)

      expect(YAML).to have_received(:load_file).with(%r(City/Area\.yml$))
    end

    it 'should return with Restaruants' do
      described_class.stub(:config_for) { [{ name: 'Test', scraper: { class: 'Facebook', params: '1', }, filter: { class: 'Hungarian' } }] }

      restaurants = described_class.restaurants_for(location)

      expect(restaurants).to have(1).restaurant
      expect(restaurants[0]).to be_a(DailyMenu::Restaurant)
    end
  end

  describe '.menus_for' do
    it 'should get the restaurants' do
      described_class.stub(:restaurants_for) { [] }

      described_class.menus_for(location)

      expect(described_class).to have_received(:restaurants_for).with(location)
    end

    it 'should return with correct items' do
      menu = double('Menu')
      restaurant = double('Restaurant', menu: menu)
      described_class.stub(:restaurants_for) { [restaurant] }

      menus = described_class.menus_for(location)

      expect(menus).to have(1).menus
      expect(menus).to include([restaurant, menu])
    end
  end

end
