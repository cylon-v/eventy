require 'spec_helper'
require './domain/invoice'
require './domain/errors/validation_error'


RSpec.describe Invoice do
  before :each do
    @email_service = double(:email_service)
    allow(@email_service).to receive(:notify)

    @customer_email = 'customer@example.com'
    @customer = double(:customer, email: @customer_email, name: 'Customer')

    @event_name = 'Event'
    @event = double(:event, name: @event_name)
    allow(@event).to receive(:add_invite)

    attrs = {customer: @customer, event: @event}
    @invoice = Invoice.new(attrs, @email_service)
  end

  describe 'initialize' do
    context 'when customer is not specified' do
      it 'raises ValidationError' do
        attrs = {event: @event}
        expect{Invoice.new(attrs, @email_service)}.to raise_error ValidationError
      end
    end

    context 'when event is not specified' do
      it 'raises ValidationError' do
        attrs = {customer: @customer}
        expect{Invoice.new(attrs, @email_service)}.to raise_error ValidationError
      end
    end

    context 'when all required parameters are specified' do
      it 'successfully creates an instance' do
        attrs = {customer: @customer, event: @event}
        expect{Invoice.new(attrs, @email_service)}.not_to raise_error
      end

      it 'invoice should be not paid' do
        expect(@invoice.paid?).to equal(false)
      end
    end
  end

  describe 'calculate' do
    it 'calculates invoice amount for the event' do
      allow(@event).to receive(:sent_invites_count).and_return(17)
      allow(@event).to receive(:accepted_invites_count).and_return(8)

      expect(@invoice.calculate).to equal(4.9)
    end
  end

  describe 'pay' do
    it 'makes the invoice paid' do
      @invoice.pay
      expect(@invoice.paid?).to equal(true)
    end

    it 'sends email notification' do
      message = "Dear Customer, \n your invoice for event Event has been paid."
      expect(@email_service).to receive(:notify).with(@customer_email, @event_name, message)
      @invoice.pay
    end
  end
end