require 'spec_helper'
require './domain/event'
require './domain/errors/validation_error'


RSpec.describe Event do
  describe 'initialize' do
    it 'raises ValidationError when name is not specified' do
      attrs = {date_time: DateTime.now, invites_limit: 10, customer: Object.new}
      expect{Event.new(attrs)}.to raise_error ValidationError
    end

    it 'raises ValidationError when date_time is not specified' do
      attrs = {name: 'Cool Party', invites_limit: 10, customer: Object.new}
      expect{Event.new(attrs)}.to raise_error ValidationError
    end

    it 'raises ValidationError when invites_limit is not specified' do
      attrs = {name: 'Cool Party', date_time: DateTime.now, customer: Object.new}
      expect{Event.new(attrs)}.to raise_error ValidationError
    end

    it 'raises ValidationError when customer is not specified' do
      attrs = {name: 'Cool Party', date_time: DateTime.now}
      expect{Event.new(attrs)}.to raise_error ValidationError
    end

    it 'creates an instance if all parameters are specified correctly' do
      attrs = {name: 'Cool Party', date_time: DateTime.now, invites_limit: 10, customer: Object.new}
      expect{Event.new(attrs)}.not_to raise_error
    end
  end

  describe 'add_invite' do
    context 'when invites_sent is less than invites_limit' do
      before :each do
        @event = Event.new(name: 'Event', date_time: DateTime.now, invites_limit: 5, customer: Object.new)
      end

      it 'increases invites_sent by 1' do
        expect(@event.invites_sent).to eql(0)
        @event.add_invite
        expect(@event.invites_sent).to eql(1)
      end
    end

    context 'when invites_sent is equal to invites_limit' do
      before :each do
        @event = Event.new(name: 'Event', date_time: DateTime.now, invites_limit: 1, customer: Object.new)
      end

      it 'raises ValidationError' do
        @event.add_invite # invites_sent = 1
        expect{@event.add_invite}.to raise_error ValidationError
      end
    end
  end
end