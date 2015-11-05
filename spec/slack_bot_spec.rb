require 'spec_helper'

describe SlackBot do
  it 'has a version number' do
    expect(SlackBot::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
