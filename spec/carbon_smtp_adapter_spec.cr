require "./spec_helper"

SMTP_PORT = 30025

email_store = Store.new
smtp_server = SMTPServer.new(email_store, SMTP_PORT)
smtp_server.run

Carbon::SmtpAdapter.configure do |settings|
  settings.port = SMTP_PORT
  settings.use_tls = false
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
  attachment hello
  attachment bye

  def hello
    {
      io:        IO::Memory.new("Hello"),
      file_name: "hello.txt",
      mime_type: "text/plain",
    }
  end

  def bye
    {
      io:        IO::Memory.new("Bye"),
      cid:       "unique_bar@myapp.com",
      file_name: "bye.txt",
      mime_type: "text/plain",
    }
  end
end

class NoHtmlEmail < BaseEmail
  from Carbon::Address.new("My App Name", "support@myapp.com")
  to "fred@example.org"
  subject "NoHtml Subject"
  templates text
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
    received_email.should match(/hello\.txt/)
    received_email.should match(/SGVsbG8=/)
    received_email.should match(/bye\.txt/)
    received_email.should match(/Qnll/)
  end

  it "sends with just text template" do
    email = NoHtmlEmail.new
    delivered = Carbon::SmtpAdapter.new.deliver_now(email)

    delivered.should_not eq(nil)
  end
end
