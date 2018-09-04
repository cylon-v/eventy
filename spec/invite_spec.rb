require 'spec_helper'
require './domain/invite'
require './domain/errors/validation_error'


RSpec.describe Invite do
  describe 'initialize' do
    it 'raises ValidationError when name is not specified' do
      attrs = {email: 'vlad@example.com', event: Object.new}
      expect{Invite.new(attrs)}.to raise_error ValidationError
    end

    it 'raises ValidationError when email is not specified' do
      attrs = {email: 'vlad@example.com', event: Object.new}
      expect{Invite.new(attrs)}.to raise_error ValidationError
    end

    it 'raises ValidationError when event is not specified' do
      attrs = {name: 'Vlad', email: 'vlad@example.com'}
      expect{Invite.new(attrs)}.to raise_error ValidationError
    end

    it 'creates an instance if all parameters are specified correctly' do
      attrs = {name: 'Vlad', email: 'vlad@example.com', event: Object.new}
      expect{Invite.new(attrs)}.not_to raise_error
    end
  end
end