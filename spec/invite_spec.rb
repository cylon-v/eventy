require 'spec_helper'
require './domain/invite'
require './domain/errors/validation_error'


RSpec.describe Invite do
  before :each do
    @email_service = double(:email_service)
    allow(@email_service).to receive(:notify)

    @event = double(:event)
    allow(@event).to receive(:add_invite)
  end

  describe 'initialize' do
    it 'raises ValidationError when name is not specified' do
      attrs = {email: 'vlad@example.com', event: @event}
      expect{Invite.new(attrs, @email_service)}.to raise_error ValidationError
    end

    it 'raises ValidationError when email is not specified' do
      attrs = {email: 'vlad@example.com', event: @event}
      expect{Invite.new(attrs, @email_service)}.to raise_error ValidationError
    end

    it 'raises ValidationError when event is not specified' do
      attrs = {name: 'Vlad', email: 'vlad@example.com'}
      expect{Invite.new(attrs, @email_service)}.to raise_error ValidationError
    end

    it 'creates an instance if all parameters are specified correctly' do
      expect(@event).to receive(:add_invite).with instance_of(Invite)
      attrs = {name: 'Vlad', email: 'vlad@example.com', event: @event}
      expect{Invite.new(attrs, @email_service)}.not_to raise_error
    end
  end
end