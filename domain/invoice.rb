require './domain/mixins/validation'

class Invoice
  include Validation

  attr_reader :amount, :customer

  def initialize(attrs={}, email_service)
    attrs.must_contain :event, :customer

    @event = attrs[:event]
    @customer = attrs[:customer]
    @email_service = email_service

    @paid = false
  end

  def calculate
    @amount = (@event.accepted_invites_count * 4 + @event.sent_invites_count) * 0.1
  end

  def pay
    @paid = true
  end
end