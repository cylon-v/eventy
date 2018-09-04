require './domain/mixins/validation'

class Invite
  include Validation

  def initialize(attrs)
    attrs.must_contain :email, :name, :event

    @email = attrs[:email]
    @name = attrs[:name]
    @event = attrs[:event]
  end
end