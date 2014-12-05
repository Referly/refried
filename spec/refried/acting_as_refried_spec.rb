require 'spec_helper'

describe "a class acting as refried" do
  klass = class IAmRefried; acts_as_refried; end
  it_behaves_like "a class acting as a getter", klass
end

describe 'an instance of a class that is acting as refried' do
  klass = class IAmRefried; acts_as_refried; end
  it_behaves_like "an instance of a class that is acting as a getter", klass
end