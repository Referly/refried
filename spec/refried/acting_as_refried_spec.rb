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
end