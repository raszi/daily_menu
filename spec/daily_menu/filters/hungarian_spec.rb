require 'spec_helper'

module DailyMenu
  describe Filters::Hungarian do
    def load_fixture(name)
      fixture_path = DailyMenu::ROOT.join('fixtures', 'feed_entries', 'hu', name)
      YAML.load_file(fixture_path).map { |text| Entry.new(text, Time.now) }
    end

    let(:menu_entries) { load_fixture('menu_entries.yml') }
    let(:other_entries) { load_fixture('other_entries.yml') }

    let(:filter) { described_class.new }

    describe '#matches?' do
      it 'should return true on valid menus' do
        menu_entries.each do |menu|
          expect(filter.matches?(menu)).to be_true
        end
      end

      it 'should return false on non-menu entries' do
        other_entries.each do |other|
          expect(filter.matches?(other)).to be_false
        end
      end
    end
  end
end
