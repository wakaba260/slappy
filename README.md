# SlackBot

[![Build Status](https://travis-ci.org/yuemori/slack_bot.svg)](https://travis-ci.org/yuemori/slack_bot)
[![Coverage Status](https://coveralls.io/repos/yuemori/slack_bot/badge.svg?branch=master&service=github)](https://coveralls.io/github/yuemori/slack_bot?branch=master)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'slack_bot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install slack_bot

## Usage

TODO: Write usage instructions here

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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/slack_bot. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

