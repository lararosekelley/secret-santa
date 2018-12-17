# SecretSanta

> Send a text message to let everyone know their Secret Santa recipient!

[![Gem](https://img.shields.io/gem/v/secretsanta.svg?style=flat)](http://rubygems.org/gems/secretsanta)
[![Build Status](https://travis-ci.org/tylucaskelley/secret-santa.svg?branch=master)](https://travis-ci.org/tylucaskelley/secret-santa)

---

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'secretsanta'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install secretsanta

## Usage

First, head on over to [Twilio](https://www.twilio.com/console) and get a phone number with texting capabilities. You
can then run `secretsanta` from the command line (see below).

Example:

    $ secretsanta -a ACCOUNT_SID -t AUTH_TOKEN -f FROM_NUMBER -p PARTICIPANTS_FILE

Alternatively, set the following environment variables:

- `TWILIO_ACCOUNT_SID`
- `TWILIO_AUTH_TOKEN`
- `TWILIO_PHONE_NUMBER`

The participants file is a JSON file, containing an array of people going to your event. It needs to be formatted as
follows:

```json
{
  "participants": [
    {
      "name": "John Doe",
      "number": "+1 (123) 456-7890",
      "disallow": [
        "Jane Doe"
      ],
      "is_assigned": false,
      "has_assignment": false
    }
  ]
}
```

The `disallow` array is optional, and contains an array of people the participant is not allowed to be paired with.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/tylucaskelley/secret-santa).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
