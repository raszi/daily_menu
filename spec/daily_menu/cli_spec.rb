require 'spec_helper'

module DailyMenu
  describe CLI do
    describe '.start' do

      context 'when passing no location' do
        it 'should raise an error when no config file found' do
          File.stub(:exists?) { true }
          File.stub(:readable?) { true }

          expect { described_class.start([]) }.to raise_error
        end

        it 'should read the rc file' do
          rc_file = double('RC file', read: 'Foo/Bar')

          described_class.stub(:file_accessible?) { true }
          File.stub(:new).with(described_class::RC_FILE) { rc_file }
          described_class.stub(:configs_for_location) { [] }
          described_class.stub(:ap)

          described_class.start([])

          expect(rc_file).to have_received(:read)
        end
      end

      context 'when passing the location' do
        it 'should raise an error when no config file found' do
          File.stub(:exists?) { false }

          expect { described_class.start(['Budapest/Central']) }.to raise_error RuntimeError
        end
      end

    end
  end
end
