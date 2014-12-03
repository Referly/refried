require 'rspec'
require_relative '../spec_helper'

describe 'Refried::Puter' do

  describe 'Refried::Puter::ActsAsPuter' do
    it 'exposes the .acts_as_puter method on Object' do
      expect(Object).to respond_to :acts_as_puter
    end

    it 'does not expose the .puter_mode= method on Object' do
      expect(Object).not_to respond_to :puter_mode=
    end

    it 'does not expose the .puter_mode method on Object' do
      expect(Object).not_to respond_to :puter_mode
    end
  end
end