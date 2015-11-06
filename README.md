# Slappy

[![Build Status](https://travis-ci.org/wakaba260/Slappy.svg)](https://travis-ci.org/wakaba260/slappy)
[![Coverage Status](https://coveralls.io/repos/wakaba260/slappy/badge.svg?branch=master&service=github)](https://coveralls.io/github/wakaba260/slappy?branch=master)

This gem support to make slack bot with hubot like interface.
Use the Slack Realtime API(see the [official-documentation](https://api.slack.com/rtm)).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'slappy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install slappy

## Usage

```ruby
require 'slappy'

slappy = Slappy::Client.new(ENV['SLACK_TOKEN'])

# called when start up
slappy.hello do
  puts 'successfly connected'
end

# called when match message
slappy.hear(/foo/) do
  puts 'foo'
end

# called when match message with pattern match
slappy.hear(/bar (.*)/) do |event|
  puts event.match_data[1]
end

# event object is slack event JSON (convert to [hashie](https://github.com/intridea/hashie))
slappy.hear(/bar (.*)/) do |event|
  puts event.channel #=> channel
  puts event.match_data[1] #=> event.text.match(pattern) value
end

robot.start
```

## How to run tests

Please create a file named .env on the root of this repository. You can use .env.example file as a template

```
cp .env.example .env
```

and edit `.env` file properly.

```
SLACK_TOKEN=abcd-1234567890-1234567890-1234567890
```

Then run tests.

```
bundle install
bundle exec rspec
```

## Feature

- [] Send Message
- [] Support private channel
- [] Support Schedule event (cron like)
- [] Generate template settings
- [] CLI commands
- [] Add bot name
- [] client#respond (hubot#respond)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/Slappy. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

