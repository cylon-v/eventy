class Hash
  def must_contain(*names)
    names.each do |name|
      raise ValidationError, "#{name} is not present in attributes hash." unless key?(name)
    end
  end
end