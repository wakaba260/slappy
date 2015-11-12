# Slappy

[![Gem Version](https://badge.fury.io/rb/slappy.svg)](https://badge.fury.io/rb/slappy)
[![Build Status](https://travis-ci.org/wakaba260/slappy.svg?branch=master)](https://travis-ci.org/wakaba260/slappy)
[![Code Climate](https://codeclimate.com/github/wakaba260/slappy/badges/gpa.svg)](https://codeclimate.com/github/wakaba260/slappy)
[![Test Coverage](https://codeclimate.com/github/wakaba260/slappy/badges/coverage.svg)](https://codeclimate.com/github/wakaba260/slappy/coverage)
[![Dependency Status](https://gemnasium.com/wakaba260/slappy.svg)](https://gemnasium.com/wakaba260/slappy)

This gem support to make slack bot, inspire from [hubot](https://github.com/github/hubot) and [sinatra](https://github.com/sinatra/sinatra).

Use the Slack Realtime API and Web API(see the [official-documentation](https://api.slack.com)).

## Quick Start

### 1. Generate Slack API Token

Slack API Token generate from [official page](https://api.slack.com/web).

### 2. Set environment variable to Slack API Token

Slappy references `ENV['SLACK_TOKEN']` default.

### 3. Run generator

Execute then command to generate project:


    $ slappy new project-name


If you want to use current directory, execute then command:

    $ slappy new

(If you use bundler, add `bundle exec` prefix)

### 4. Write code

Create ruby file to under `project-name/slappy-scripts`, and written code.

Example:

```ruby
# catch pattern
hear '^hello, slappy!' do |event|
  logger.info 'received message!'
  say 'hello!!', channel: event.channel #=> respond message to channel
end
```

There scripts not share scopes with other scripts.

### 5. Slappy start

Execute then command in project root directory.

    $ slappy start

(Stop: Input Ctrl+c)

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
### ENV
Store configuration value in environment variables. They are easy to change between deploys without changing any code.

```
SLACK_TOKEN - required (when not configured)
```

### Configure
Configure default settings.
There configrations effect on send message to slack when use `say` method and should override when option given.

#### Example

```ruby
require 'slappy'

Slappy.configure do |config|
  config.token = 'foobar'
  config.robot.username   = 'slappy'
  config.robot.channel    = '#general'
  config.robot.icon_emoji = ':slappy:'
end

Slappy.say 'hello!' #=> username: slappy, channel: '#general', icon_emoji: ':slappy:'
```

#### Configuration Parameters

```
token            - default: ENV['SLACK_TOKEN']
scripts_dir_path - default : 'slappy-scripts'

robot.botname    - not effect now
robot.username   - default: 'slappy'
robot.icon_emoji - default: nil
robot.channel    - default: '#general'
robot.icon_url   - default: nil
```

### Basic Usage

If you not want execute `slappy start` command, written by (require `'slappy/dsl'` use DSL):

```ruby
require 'slappy'

# called when start up
Slappy.hello do
  Slappy.logger.info 'successfly connected'
end

# called when match message
Slappy.hear 'foo' do
  Slappy.logger.info 'foo'
end

# use regexp in string literal
Slappy.hear 'bar (.*)' do |event|
  Slappy.logger.info event.matches[1] #=> Event#matches return MatchData object
end

# event object is slack event JSON (convert to Hashie::Mash)
Slappy.hear '^bar (.*)' do |event|
  Slappy.logger.info event.channel #=> channel id
  Slappy.say 'slappy!', channel: event.channel #=> to received message channel
  Slappy.say 'slappy!', channel: '#general'
  Slappy.say 'slappy!', username: 'slappy!', icon_emoji: ':slappy:'
end

# use regexp literal
Slappy.hear /^foobar/ do
  Slappy.logger.info 'slappppy!'
end

Slappy.start #=> Start slappy process
```

## Release Note

- v0.4.0
  - Support logger
  - Support load lib directory
  - Add New command
    - version
  - Choise dsl enabled in slappy_config

- v0.3.0
  - Introduce DSL
  - Introduce CLI commands
    - start
    - new
  - Use String literal for hear parameter
  - Chose dsl use in slappy_config

- v0.2.0
  - Modify interface

- v0.1.0
  - Release

## Feature

- [ ] Execute in shell (because testable).
- [ ] Support private channel
- [ ] Support Schedule event (cron like)
- [ ] Add bot name
- [ ] client#respond (hubot#respond like)
- [ ] Split chat adapter

## Contributing

1. Fork it ( http://github.com/wakaba260/slappy/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

