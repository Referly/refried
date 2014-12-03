require 'simplecov'
SimpleCov.profiles.define 'refried' do
  add_filter '/spec'
  add_filter '/test'
end