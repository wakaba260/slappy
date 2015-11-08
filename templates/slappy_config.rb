require 'slappy/dsl'

Slappy.configure do |config|
  config.token = ENV['SLACK_TOKEN']
  config.robot.username   = 'slappy'
  config.robot.channel    = nil
  config.robot.icon_emoji = nil
  config.robot.icon_url   = nil
  config.scripts_dir_path = 'slappy-scripts'
end
