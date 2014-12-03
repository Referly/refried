require 'rspec'
require 'json'
require_relative '../spec_helper'

describe 'A class that is acting as a puter' do
  subject { class IPut; acts_as_puter; end }
  it { is_expected.to respond_to :puter_mode= }
  it { is_expected.to respond_to :puter_mode }

  # Cannot use a let here because it needs to be accessible outside of it blocks
  valid_modes = [:simple, :type_map, :alias_map]
  let(:i_put_class) { class IPut; acts_as_puter; end }
  let(:i_put) { i_put_class.new }

  describe '#puter_mode=' do
    let(:mut) { i_put.class.puter_mode = mode }
    let(:mode) { :invalid_mode }
    it 'raises an ArgumentError if receives an argument other than :simple, :type_map, or :alias_map' do
      expect { mut }.to raise_error ArgumentError
    end
    context 'when receiving a mode parameter that is valid' do
      modes = valid_modes
      modes.each do |valid_mode|
        context "when the mode parameter is :#{valid_mode}" do
          it "sets the @puter_mode to :#{valid_mode}" do
            i_put.class.puter_mode = valid_mode
            expect(i_put.class.instance_variable_get(:@puter_mode)).to eq valid_mode
          end
          it "returns :#{valid_mode} of the argument" do
            expect(i_put.class.puter_mode = valid_mode).to eq valid_mode
          end
        end
      end
    end
  end

  describe '#puter_mode' do
    it 'returns the current mode of the puter' do
      mode = :alias_map
      i_put.class.puter_mode = mode
      expect(i_put.class.puter_mode).to eq mode
    end
    context 'when the puter mode has not been set' do
      before(:each) { i_put.class.instance_variable_set(:@puter_mode, nil) }
      subject { i_put.class.puter_mode }
      it 'returns a valid default value' do
        is_expected.to satisfy { |mode| valid_modes.include? mode }
      end
    end
  end
end

describe 'An instance of a class that is acting as a puter' do
  let(:i_put_class) { class IPut; acts_as_puter; end }
  let(:i_put) { i_put_class.new }
  subject { i_put }
  it { is_expected.to respond_to :put }
  it { is_expected.to respond_to :tube }
  it { is_expected.to respond_to :generate_message }

  describe '#generate_message' do
    context 'receives one argument' do
      subject(:mut) { i_put.generate_message argument }
      context 'that responds to the to_json method' do
        let(:expected) { ["abcdefg"].to_json }
        let(:argument) { a = Object.new; allow(a).to receive(:to_json).and_return(expected); a }
        it { is_expected.to eq expected }
      end
      context 'that does not respond to the to_json method' do
        let(:argument) { a = Object.new; allow(a).to receive(:to_json).and_raise(NoMethodError); a }
        it 'is expected to raise NoMethodError' do
          expect { mut }.to raise_error NoMethodError
        end
      end
    end
  end

  describe '#tube' do
    let(:selectors) { nil }

    ### MUT
    subject(:mut) { i_put.tube selectors }
    ### MUT

    context 'when the puter_mode is invalid' do
      before { i_put_class.instance_variable_set(:@puter_mode, :invalid_mode) }
      after { i_put_class.puter_mode = :simple } # Restore invalid state to valid state
      it 'is expected to raise ArgumentError' do
        expect { mut }.to raise_error ArgumentError
      end
    end
    context 'when the puter_mode is :simple' do
      before { i_put_class.puter_mode = :simple }
      context 'and the selectors hash argument is not empty' do
        let(:selectors) { {foo: 'bar'} }
        it 'is expected to raise ArgumentError' do
          expect { mut }.to raise_error ArgumentError
        end
      end
      context 'and the selectors hash argument is empty' do
        let(:expected) { Refried.tubes.find 'iput' }
        it { is_expected.to be_a Beaneater::Tube }
        it { pending("Get == working between Beaneater tubes"); is_expected.to eq expected }
      end
    end
    context 'when the puter_mode is :alias_map' do
      before { i_put_class.puter_mode = :alias_map }
      context 'and the :alias argument is not specified' do
        let(:selectors) { nil }
        it 'raises an Argument Error' do
          expect { mut }.to raise_error ArgumentError
        end
      end
      context 'and the :alias argument is a Symbol' do
        let(:tube_alias) { :test_tube_alias }
        let(:selectors) { { alias: :test_tube_alias } }
        context 'and the tube alias is in the puter_tube_alias_map' do
          before { i_put.instance_variable_set(:@puter_tube_alias_map, { :test_tube_alias => 'test_tube_name' }) }
          after { i_put.instance_variable_set(:@puter_tube_alias_map, nil) }
          it { is_expected.to be_a Beaneater::Tube }
        end
        context 'but the tube alias is not in the puter_tube_alias_map' do
          after { i_put.instance_variable_set(:@puter_tube_alias_map, nil) }
          it 'raises an ArgumentError' do
            expect { mut }.to raise_error ArgumentError
          end
        end
      end
      context 'and the :alias argument is not a Symbol' do
        let(:arguments) { { alias: "not_a_symbol" } }
        it 'raises an ArgumentError' do
          expect { mut }.to raise_error ArgumentError
        end
      end
    end
  end

  describe '#put' do
    context 'with puter_mode of :alias_map' do
      let(:item) { 123 }
      let(:expected) { item.to_json }
      after { i_put.tube(alias: :foobar).clear }
      it 'successfully adds the item to the beanstalk queue' do
        i_put.puter_tube_alias_map = { foobar: 'foobar' }
        expect(i_put.put(item, :foobar)[:status]).to eq "INSERTED"
      end
    end
  end
end