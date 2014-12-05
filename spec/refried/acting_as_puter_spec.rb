require 'json'
require 'spec_helper'

describe 'A class that is acting as a puter' do
  klass = class IPut; acts_as_puter; end
  it_behaves_like "a class acting as a puter", klass
end

describe 'An instance of a class that is acting as a puter' do
  klass = class IPut; acts_as_puter; end
  it_behaves_like "an instance of a class that is acting as a puter", klass
end