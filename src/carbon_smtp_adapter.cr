require "habitat"
require "carbon"
require "email"

require "./carbon/adapters/smtp_adapter"

module CarbonSmtpAdapter
  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}
end
