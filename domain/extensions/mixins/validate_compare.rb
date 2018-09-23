module ValidateCompare
  def must_be
    @to_compare = true
    self
  end

  def >(value)
    if @to_compare
      @to_compare = false
      unless self > value
        raise ValidationError, "#{@instance_name} must be more than #{value}."
      end
    else
      super
    end
  end

  def >=(value)
    if @to_compare
      @to_compare = false
      unless self >= value
        raise ValidationError, "#{@instance_name} must be more than or equal to #{value}."
      end
    else
      super
    end
  end

  def <(value)
    if @to_compare
      @to_compare = false
      unless self < value
        raise ValidationError, "#{@instance_name} must be less than #{value}."
      end
    else
      super
    end
  end

  def <=(value)
    if @to_compare
      @to_compare = false
      unless self <= value
        raise ValidationError, "#{@instance_name} must be less than or equal to #{value}."
      end
    else
      super
    end
  end

  def ==(value)
    if @to_compare
      @to_compare = false
      unless self <= value
        raise ValidationError, "#{@instance_name} must be equal to #{value}."
      end
    else
      super
    end
  end
end