require './domain/extensions/mixins/validate_compare'

module Validation
  require './domain/extensions/hash'

  [Date, DateTime, String, Integer, Fixnum].each do |type|
    type.include(ValidateCompare)
  end
end