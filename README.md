# carbon\_smtp\_adapter

A simple SMTP-Adapter for [carbon](https://github.com/luckyframework/carbon).

## Versioning

The current plan is to track carbon's major and minor numbers, so that
carbon\_smtp\_adapter `0.1.x` is compatible with carbon `0.3.x` and so on.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  carbon_smtp_adapter:
    github: your-github-user/carbon_smtp_adapter
```

## Usage

```crystal
require "carbon_smtp_adapter"

# configure your base email class to use the smtp adapter:
BaseEmail.configure do |setting|
  settings.adapter = Carbon::SmtpAdapter.new
end
```

By default, carbon will try to deliver the email to an smtp server running on
`localhost` and listening on port `25`. If you need different settings, you can
configure the following (values shown are the defaults):

```crystal
Carbon::SmtpAdapter.configure do |settings|
  settings.host = "localhost"
  settings.port = 25
  settings.helo_domain = nil
  settings.use_tls = true
  settings.username = nil
  settings.password = nil
end
```

## Contributing

1. Fork it ([https://github.com/oneiros/carbon_smtp_adapter/fork](https://github.com/oneiros/carbon_smtp_adapter/fork))
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [oneiros](https://github.com/oneiros) David Roetzel - creator, maintainer

With many thanks to:

- [paulcsmith](https://github.com/paulcsmith) Paul Smith - creator of carbon
- [arcage](https://github.com/arcage) arcage - creator of crystal-email
- [tijn](https://github.com/tijn) Tijn Schuurmans - creator of devmail
