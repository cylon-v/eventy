require './domain/mixins/validation'

class Event
  include Validation

  attr_reader :name, :date_time

  def initialize(attrs = {})
    attrs.must_contain :name, :date_time, :invites_limit, :customer

    @name = attrs[:name]
    @date_time = attrs[:date_time]
    @invites_limit = attrs[:invites_limit]
    @invites = []
  end

  def add_invite(invite)
    if @invites.length >= @invites_limit
      raise ValidationError, 'Event reached maximum invites number'
    end

    @invites.push(invite)
  end

  def sent_invites_count
    @invites.length
  end

  def accepted_invites_count
    @invites.select{|i| i.accepted}.length
  end
end