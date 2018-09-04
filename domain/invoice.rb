require './domain/mixins/validation'

class Invoice
  include Validation

  def initialize(attrs={})
    attrs.must_contain :event, :customer

    @event = attrs[:event]
    @customer = attrs[:customer]
  end
end