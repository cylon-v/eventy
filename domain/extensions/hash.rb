class Hash
  def must_contain(*names)
    names.each do |name|
      raise ValidationError, "#{name} is not present in attributes hash." unless key?(name)
    end
  end

  def value_of(name)
    value = self[name]
    value.instance_variable_set('@instance_name', name)
    value
  end
end