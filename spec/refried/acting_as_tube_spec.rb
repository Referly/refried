require 'spec_helper'

describe "a class acting as tube" do
  klass = class IAmTube; acts_as_tube; end
  it_behaves_like "a class acting as a getter", klass
  it_behaves_like "a class acting as a puter", klass
end

describe 'an instance of a class that is acting as tube' do
  klass = class IAmTube; acts_as_tube; end
  it_behaves_like "an instance of a class that is acting as a getter", klass
  it_behaves_like "an instance of a class that is acting as a puter", klass

  describe "#tube_name" do
    let(:i_tube) do
      t = klass.new
      allow(t).to receive :puter_tube_name=
      allow(t).to receive :getter_tube_name=
      t
    end
    let(:tube_name) { "sometube" }
    subject(:mut) { i_tube.tube_name = tube_name }
    it "calls #puter_tube_name= with the tube_name argument" do
      mut
      expect(i_tube).to have_received(:puter_tube_name=).with tube_name
    end
    it "calls #getter_tube_name= with the tube_name argument" do
      mut
      expect(i_tube).to have_received(:getter_tube_name=).with tube_name
    end
  end
end