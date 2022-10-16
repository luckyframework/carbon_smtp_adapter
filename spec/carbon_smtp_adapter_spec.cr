require "./spec_helper"

SMTP_PORT = 30025

email_store = Store.new
smtp_server = SMTPServer.new(email_store, SMTP_PORT)
smtp_server.run

Carbon::SmtpAdapter.configure do |settings|
  settings.port = SMTP_PORT
  settings.use_tls = false
  settings.helo_domain = "localhost"
end

abstract class BaseEmail < Carbon::Email
end

BaseEmail.configure do |settings|
  settings.adapter = Carbon::SmtpAdapter.new
end

class TestEmail < BaseEmail
  from Carbon::Address.new("My App Name", "support@myapp.com")
  to "fred@example.org"
  subject "Test Subject"
  templates text, html
  header "X-Crystal-Version", "0.27"
  header "Reply-To", "support@myapp.com"
  header "Message-ID", "<abc123@myapp.com>"
  header "Return-Path", "support@myapp.com"
  header "Sender", "support@myapp.com"
end

describe CarbonSmtpAdapter do
  it "works" do
    email = TestEmail.new
    Carbon::SmtpAdapter.new.deliver_now(email)

    email_store.count.should eq(1)
    received_email = email_store.messages.last
    received_email.should match(/From: My App Name <support@myapp\.com>/)
    received_email.should match(/To: fred@example\.org/)
    received_email.should match(/Subject: Test Subject/)
    received_email.should match(/Content-Type: text\/plain/)
    received_email.should match(/Content-Type: text\/html/)
    received_email.should match(/X-Crystal-Version: 0\.27/)
  end
end
