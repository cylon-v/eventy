require './domain/mixins/validation'

class Event
  include Validation

  attr_reader :invites_sent

  def initialize(attrs = {})
    attrs.must_contain :name, :date_time, :invites_limit, :customer

    @name = attrs[:name]
    @date_time = attrs[:date_time]
    @invites_limit = attrs[:invites_limit]
    @invites_sent = 0
  end

  def add_invite
    if @invites_sent == @invites_limit
      raise ValidationError, 'Event reached maximum invites number'
    end

    @invites_sent += 1
  end
end