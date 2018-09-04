require './domain/mixins/validation'

class Customer
  include Validation

  def initialize(attrs = {})
    attrs.must_contain :name

    @name = attrs[:name]
  end
end