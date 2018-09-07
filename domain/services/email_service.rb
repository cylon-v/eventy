class EmailService
  def notify(email, subject, message)
    puts "Sending email to #{email}:"
    puts "Subject: #{subject}"
    puts "Message: \n #{message}"
  end
end