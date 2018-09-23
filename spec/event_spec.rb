require 'spec_helper'
require './domain/event'
require './domain/invite'
require './domain/errors/validation_error'
require 'active_support/time'

valid_date = DateTime.now + 1.day

RSpec.describe Event do
  before :each do
    @customer = double(:customer)
  end

  describe 'initialize' do
    it 'raises ValidationError when name is not specified' do
      attrs = {date_time: valid_date, invites_limit: 10, customer: @customer}
      expect{Event.new(attrs)}.to raise_error ValidationError
    end

    it 'raises ValidationError when date_time is not specified' do
      attrs = {name: 'Cool Party', invites_limit: 10, customer: @customer}
      expect{Event.new(attrs)}.to raise_error ValidationError
    end

    it 'raises ValidationError when date_time is in past' do
      attrs = {name: 'Cool Party', date_time: DateTime.yesterday, invites_limit: 10, customer: @customer}
      expect{Event.new(attrs)}.to raise_error ValidationError
    end

    it 'raises ValidationError when invites_limit is not specified' do
      attrs = {name: 'Cool Party', date_time: valid_date, customer: @customer}
      expect{Event.new(attrs)}.to raise_error ValidationError
    end

    it 'raises ValidationError when customer is not specified' do
      attrs = {name: 'Cool Party', date_time: valid_date}
      expect{Event.new(attrs)}.to raise_error ValidationError
    end

    it 'creates an instance if all parameters are specified correctly' do
      attrs = {name: 'Cool Party', date_time: valid_date, invites_limit: 10, customer: @customer}
      expect{Event.new(attrs)}.not_to raise_error
    end
  end

  describe 'add_invite' do
    context 'when invites_sent is less than invites_limit' do
      before :each do
        email_service = double(:email_service)
        allow(email_service).to receive(:notify)
        @event = Event.new(name: 'Event', date_time: valid_date, invites_limit: 5, customer: @customer)
      end

      it 'increases sent_invites_count by 1' do
        expect(@event.sent_invites_count).to eql(0)
        invite = double(:invite)
        @event.add_invite(invite)
        expect(@event.sent_invites_count).to eql(1)
      end
    end

    context 'when invites_sent is equal to invites_limit' do
      before :each do
        @event = Event.new(name: 'Event', date_time: valid_date, invites_limit: 1, customer: @customer)

        invite1 = double(:invite1)
        @event.add_invite(invite1) # invites_sent = 1
      end

      it 'raises ValidationError' do
        invite2 = double(:invite2)
        expect{@event.add_invite(invite2)}.to raise_error(ValidationError, 'Event reached maximum invites number')
      end
    end

    context 'when invite with same email has already been added' do
      before :each do
        @event = Event.new(name: 'Event', date_time: valid_date, invites_limit: 100, customer: @customer)
        invite1 = double(:invite1)
        allow(invite1).to receive(:email).and_return('same@example.com')
        @event.add_invite(invite1)
      end

      it 'raises ValidationError' do
        invite2 = double(:invite2)
        allow(invite2).to receive(:email).and_return('same@example.com')
        expect{@event.add_invite(invite2)}.to raise_error(ValidationError, 'Invite to this email has already been added')
      end
    end
  end

  describe 'sent_invites_count' do
    it 'returns count of all invites added to the event' do
      @event = Event.new(name: 'Event', date_time: valid_date, invites_limit: 100, customer: @customer)
      5.times do |i|
        invite = double("invite#{i}")
        allow(invite).to receive(:email).and_return("invite#{i}@example.com")
        @event.add_invite(invite)
      end

      expect(@event.sent_invites_count).to eql(5)
    end
  end

  describe 'accepted_invites_count' do
    it 'returns count of accepted invites added to the event' do
      @event = Event.new(name: 'Event', date_time: valid_date, invites_limit: 100, customer: @customer)
      accepted_map = [true, false, true, false, false]
      accepted_map.each_with_index do |is_accepted, index|
        invite = double("invite#{index}")
        allow(invite).to receive(:email).and_return("invite#{index}@example.com")
        allow(invite).to receive(:accepted?).and_return(is_accepted)
        @event.add_invite(invite)
      end

      expect(@event.accepted_invites_count).to eql(2)
    end
  end
end