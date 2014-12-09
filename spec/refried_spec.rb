require 'spec_helper'
require 'byebug'


describe 'Refried' do
  describe 'public API' do
    subject { Refried }
    it { is_expected.to respond_to :configuration }
    it { is_expected.to respond_to :configure }
    it { is_expected.to respond_to :tubes }

    context 'Singleton methods' do
      describe '#configure' do
        it "yields control to the specified block with a Refried::Configuration argument type" do
          expect { |b| Refried.configure(&b) }.to yield_with_args Refried::Configuration
        end
      end

      describe '#configuration' do
        subject(:mut) { Refried.configuration }
        it { is_expected.to respond_to :beanstalk_url }
        it "has a default beanstalk url of localhost" do
          expect(Refried.configuration.beanstalk_url).to eq 'localhost'
        end

        context 'when a valid block has been passed to #configure' do
          before do
            Refried.configure(&configure_block)
          end
          let(:configure_block) do
            Proc.new do |config|
              config.beanstalk_url = 'testuri'
              config.reserve_timeout = 314
            end
          end
          context 'when the configure block argument includes beanstalk_url' do
            describe '#beanstalk_url' do
              it "returns the beanstalk_url specified in the configure block" do
                expect(Refried.configuration.beanstalk_url).to eq 'testuri'
              end
            end
          end
          context 'when the configure block argument includes reserve_timeout' do
            describe '#reserve_timeout' do
              it "returns the reserve timeout specified in the configure block" do
                expect(Refried.configuration.reserve_timeout).to eq 314
              end
            end
          end
        end
      end

      describe '#tubes' do
        subject { Refried.tubes }
        before { Refried.configure reset: true }
        it { is_expected.to be_a Refried::Tubes }
      end

      describe '#jobs' do
        subject { Refried.jobs }
        before { Refried.configure reset: true }
        it { is_expected.to be_a Refried::Jobs }
      end
    end
  end
end