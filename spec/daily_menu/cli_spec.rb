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

          DailyMenu.stub(:file_accessible?) { true }
          File.stub(:new).with(described_class::RC_FILE) { rc_file }
          DailyMenu.stub(:restaurants_for) { [] }
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

      context 'when there are fetched menus' do
        let(:location) { double('Location') }
        let(:restaurant) { double('Restaurant', name: 'Name') }
        let(:entry) { double('Entry', content: 'Content', time: DateTime.now) }
        let(:menus) { [[restaurant, entry]] }

        before do
          DailyMenu.stub(:menus_for).with(location) { menus }
        end

        context 'and using terminal' do
          before do
            STDOUT.stub(:tty?) { true }
          end

          it 'should use the ColoredFormatter' do
            ColoredFormatter.stub(:print)

            described_class.start([location])

            expect(ColoredFormatter).to have_received(:print).with(restaurant, entry)
          end

          it 'should print out to console' do
            STDOUT.stub(:puts)

            described_class.start([location])

            expect(STDOUT).to have_received(:puts).at_least(:once)
          end
        end

        context 'and using pipe' do
          before do
            STDOUT.stub(:tty?) { false }
          end

          it 'should use the MarkdownFormatter' do
            MarkdownFormatter.stub(:print)

            described_class.start([location])

            expect(MarkdownFormatter).to have_received(:print).with(restaurant, entry)
          end

          it 'should print out to console' do
            STDOUT.stub(:puts)

            described_class.start([location])

            expect(STDOUT).to have_received(:puts).at_least(:once)
          end
        end
      end

    end
  end
end
