require 'spec_helper'

describe DailyMenu do
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
end
