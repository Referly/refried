require 'spec_helper'
require 'json'

describe "a class acting as a getter" do
  klass = class IGet; acts_as_getter; end
  it_behaves_like "a class acting as a getter", klass
end

describe 'an instance of a class that is acting as a getter' do
  klass = class IGet; acts_as_getter; end
  it_behaves_like "an instance of a class that is acting as a getter", klass
end