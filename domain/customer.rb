require './domain/mixins/validation'
require './domain/errors/validation_error'

class Customer
  include Validation

  attr_reader :events

  def initialize(attrs = {}, payment_service)
    attrs.must_contain :name

    @name = attrs[:name]
    @email = attrs[:email]
    @payment_service = payment_service

    @events = []
  end

  def add_event(event)
    @events.push(event)
  end

  def pay_invoice(invoice)
    if invoice.customer != self
      raise ValidationError, "Customer can pay only its own invoice"
    end

    status = @payment_service.charge(@email, invoice.amount)
    if status == 'OK'
      invoice.pay
    end
  end
end