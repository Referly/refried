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