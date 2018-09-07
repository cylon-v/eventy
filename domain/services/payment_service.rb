class PaymentService
  def charge(email, amount)
    puts "A credit card of user #{email} has been charged for $#{amount}."

    'OK'
  end
end