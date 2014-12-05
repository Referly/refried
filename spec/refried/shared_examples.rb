require 'json'

shared_examples_for "a class acting as a getter" do |klass|
  subject { klass }
  it { is_expected.to respond_to :getter_mode= }
  it { is_expected.to respond_to :getter_mode }
  it { is_expected.to respond_to :get_mode }

  valid_modes = [:tube_name]
  # let(:i_get_class) { class IGet; acts_as_getter; end }
  let(:i_get) { klass.new }

  describe '#getter_mode=' do
    let(:mut) { klass.getter_mode = mode }
    let(:mode) { :invalid_mode }
    it 'raises an ArgumentError if receives an argument other than :tube_name' do
      expect { mut }.to raise_error ArgumentError
    end
    context 'when receiving a mode parameter that is valid' do
      modes = valid_modes
      modes.each do |valid_mode|
        context "when the mode parameter is :#{valid_mode}" do
          it "sets the @getter_mode to :#{valid_mode}" do
            klass.getter_mode = valid_mode
            expect(klass.instance_variable_get(:@getter_mode)).to eq valid_mode
          end
          it "returns the argument's value: #{valid_mode}" do
            expect(klass.getter_mode = valid_mode).to eq valid_mode
          end
        end
      end
    end
  end

  describe '#getter_mode' do
    it 'returns the current mode of the getter' do
      mode = :tube_name
      i_get.class.getter_mode = mode
      expect(i_get.class.getter_mode).to eq mode
    end
    context 'when the getter mode has not been set' do
      before(:each) { i_get.class.instance_variable_set(:@getter_mode, nil) }
      subject { i_get.class.getter_mode }
      it 'returns a valid default value' do
        is_expected.to satisfy { |mode| valid_modes.include? mode }
      end
    end
  end
end

shared_examples_for "an instance of a class that is acting as a getter" do |klass|
  let(:i_get) { klass.new }
  subject { i_get }
  it { is_expected.to respond_to :get }
  it { is_expected.to respond_to :getter_tube_name }
  it { is_expected.to respond_to :getter_tube_name= }

  describe '#getter_tube_name' do
    subject(:mut) { i_get.getter_tube_name }
    context 'when getter_mode is :tube_name' do
      let(:expected) { :expected_tube_name }
      before { klass.getter_mode = :tube_name; i_get.getter_tube_name = expected }
      it { is_expected.to eq expected  }
    end
  end

  describe '#get' do
    subject(:mut) { i_get.get }
    context 'with getter_mode of :tube_name' do
      @name_of_tube = nil
      @tube = nil
      let(:item) { [123, 456] }
      let(:expected) { item.to_json }
      before do
        klass.getter_mode = :tube_name
        beanstalk = Beaneater::Pool.new(::Refried.configuration.beanstalk_url)
        @name_of_tube = "#{klass}gettergetstesttube"
        @tube = beanstalk.tubes.find @name_of_tube
        @tube.put expected
      end
      after { @tube.clear if @tube.respond_to? :clear }
      it 'returns the expected beanstalk job instance' do
        i_get.getter_tube_name = @name_of_tube
        expect(mut.body).to eq expected
      end
    end
  end
end

shared_examples_for "a class acting as a puter" do |klass|
  subject { klass }
  it { is_expected.to respond_to :puter_mode= }
  it { is_expected.to respond_to :puter_mode }
  it { is_expected.to respond_to :put_mode }

  # Cannot use a let here because it needs to be accessible outside of it blocks
  valid_modes = [:simple, :type_map, :alias_map, :tube_name]
  let(:i_put) { klass.new }

  describe '#puter_mode=' do
    let(:mut) { klass.puter_mode = mode }
    let(:mode) { :invalid_mode }
    it 'raises an ArgumentError if receives an argument other than :simple, :type_map, :alias_map, or :tube_name' do
      expect { mut }.to raise_error ArgumentError
    end
    context 'when receiving a mode parameter that is valid' do
      modes = valid_modes
      modes.each do |valid_mode|
        context "when the mode parameter is :#{valid_mode}" do
          it "sets the @puter_mode to :#{valid_mode}" do
            klass.puter_mode = valid_mode
            expect(klass.instance_variable_get(:@puter_mode)).to eq valid_mode
          end
          it "returns :#{valid_mode} of the argument" do
            expect(klass.puter_mode = valid_mode).to eq valid_mode
          end
        end
      end
    end
  end

  describe '#puter_mode' do
    it 'returns the current mode of the puter' do
      mode = :alias_map
      klass.puter_mode = mode
      expect(klass.puter_mode).to eq mode
    end
    context 'when the puter mode has not been set' do
      before(:each) { klass.instance_variable_set(:@puter_mode, nil) }
      subject { klass.puter_mode }
      it 'returns a valid default value' do
        is_expected.to satisfy { |mode| valid_modes.include? mode }
      end
    end
  end
end

shared_examples_for "an instance of a class that is acting as a puter" do |klass|
  let(:i_put_class) { klass }
  let(:i_put) { i_put_class.new }
  subject { i_put }
  it { is_expected.to respond_to :put }
  it { is_expected.to respond_to :tube }
  it { is_expected.to respond_to :generate_message }
  it { is_expected.to respond_to :tube_name }
  it { is_expected.to respond_to :tube_name= }

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
      let(:expected) { Tube.tubes.find 'iput' }
      it { is_expected.to be_a Beaneater::Tube }
      it { pending("Get == working between Beaneater tubes"); is_expected.to eq expected }
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

  describe '#puter_tube_name' do
    let(:selectors) { nil }

    subject(:mut) { i_put.puter_tube_name selectors }

    context 'when puter_mode is :simple' do
      before { i_put_class.puter_mode = :simple }
      let(:expected) { klass.to_s.downcase.to_sym }
      it { is_expected.to eq expected  }
    end

    context 'when puter_mode is :tube_name' do
      before { i_put_class.puter_mode = :tube_name; i_put.puter_tube_name = expected }
      let(:expected) { "expected_tube_name" }
      it { is_expected.to eq expected  }
    end
  end

  describe '#put' do
    let(:item) { 123 }
    let(:expected) { item.to_json }

    context 'with puter_mode of :simple' do
      let(:name_of_tube) { "simpletesttube" }
      before { i_put_class.puter_mode = :simple }
      after { i_put.tube.clear }
      it 'adds the item to the beanstalk queue' do
        expect(i_put.put(item)[:status]).to eq "INSERTED"
      end
    end
    context 'with puter_mode of :tube_name' do
      let(:name_of_tube) { "testtubetube" }
      before { i_put_class.puter_mode = :tube_name; i_put.puter_tube_name = name_of_tube }
      after { i_put.tube.clear }
      it 'adds the item to the beanstalk queue' do
        expect(i_put.put(item)[:status]).to eq "INSERTED"
      end
    end
    context 'with puter_mode of :alias_map' do
      before { i_put_class.puter_mode = :alias_map }
      after { i_put.tube(alias: :foobar).clear }
      it 'successfully adds the item to the beanstalk queue' do
        i_put.puter_tube_alias_map = { foobar: 'foobar' }
        expect(i_put.put(item, :foobar)[:status]).to eq "INSERTED"
      end
    end
  end
end