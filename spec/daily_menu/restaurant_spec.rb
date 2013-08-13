require 'spec_helper'

module DailyMenu
  describe Restaurant do

    describe '.from_hash' do
      let(:config) { { scraper: { class: 'Facebook', params: '1' }, filter: { class: 'Hungarian' } } }

      it 'should create an instance' do
        expect(described_class.from_hash(config)).to be_a(described_class)
      end
    end

    describe '#menu' do
      let(:filter) { double('Filter') }
      let(:scraper) { double('Scraper') }
      let(:restaurant) { described_class.new('Restaurant', scraper, filter) }

      it 'should fetch the menus from scraper' do
        scraper.stub(:entries) { [] }

        restaurant.menu

        expect(scraper).to have_received(:entries)
      end

      context 'when there are fetched entries' do
        let(:entries) { [Entry.new('This is a menu entry', 2), Entry.new('This is not', 1), Entry.new('This is also a menu entry', 0)] }
        before do
          scraper.stub(:entries) { entries }
        end

        it 'should call filter for filtering out menus' do
          filter.stub(:matches?) { true }

          restaurant.menu

          expect(filter).to have_received(:matches?).exactly(entries.count).times
        end

        it 'should leave in only the filtered items' do
          filter.stub(:matches?) do |entry|
            entry.content.include?('menu')
          end

          expect(restaurant.menu).to eq(Entry.new('This is a menu entry', 2))
        end
      end
    end
  end
end
