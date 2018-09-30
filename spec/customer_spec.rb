require 'spec_helper'
require './domain/customer'
require './domain/errors/validation_error'


RSpec.describe Customer do
  before :each do
    @payment_service = double(:payment_service)
    allow(@payment_service).to receive(:notify)

    @event = double(:event)
    allow(@event).to receive(:add_invite)

    @customer_email = 'customer@example.com'
    @customer = Customer.new({name: 'Customer', email: @customer_email}, @payment_service)
  end

  describe 'initialize' do
    it 'raises ValidationError when name is not specified' do
      expect {Customer.new({}, @payment_service)}.to raise_error ValidationError
    end

    it 'creates an instance if all parameters are specified correctly' do
      expect {Customer.new({name: 'Customer'}, @payment_service)}.to_not raise_error
    end
  end

  describe 'add_event' do
    it 'adds an event to the list' do
      event = double(:event)
      @customer.add_event(event)
      expect(@customer.events).to include(event)
    end
  end

  describe 'pay_invoice' do
    context "when it's another customer invoice" do
      before :each do
        another_customer = double(:another_customer)
        @invoice = double(:invoice, customer: another_customer)
      end

      it 'raises ValidationError' do
        expect {@customer.pay_invoice(@invoice)}.to raise_error ValidationError
      end
    end

    context "when it's customer's invoice" do
      before :each do
        @invoice_amount = 9.98
        @invoice = double(:invoice, customer: @customer, amount: @invoice_amount)
      end

      context 'but payment service returns an error' do
        it 'does not pay the invoice' do
          expect(@payment_service).to receive(:charge)
                                        .with(@customer_email, @invoice_amount)
                                        .and_return('FAILED')
          expect(@invoice).not_to receive(:pay)

          @customer.pay_invoice(@invoice)
        end
      end

      context 'and payment service successfully charges the account' do
        it 'does not pay the invoice' do
          expect(@payment_service).to receive(:charge)
                                        .with(@customer_email, @invoice_amount)
                                        .and_return('OK')
          expect(@invoice).to receive(:pay)

          @customer.pay_invoice(@invoice)
        end
      end
    end
  end
end