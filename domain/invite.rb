require './domain/mixins/validation'

class Invite
  include Validation

  def initialize(attrs, email_service)
    attrs.must_contain :email, :name, :event

    @email = attrs[:email]
    @name = attrs[:name]
    @event = attrs[:event]
    @accepted = false

    @event.add_invite(self)
    @email_service = email_service
  end

  def send_email
    message = "Dear #{@name}, \n you have been invited to event #{@event.name}"
    @email_service.notify(@email, @event.name, message)
  end

  def accept
    @accepted = true
  end

  def accepted?
    @accepted
  end
end