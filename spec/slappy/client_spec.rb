require 'spec_helper'

describe Slappy::Client do
  let(:client) { Slappy::Client.new(token) }
  let(:token)  { ENV['SLACK_TOKEN'] }

  describe '#hear' do
    before { size.times { client.hear(regexp) { puts 'hear' } } }
    subject { client.instance_variable_get(:@listeners)[:message] }
    let(:regexp) { /test/ }
    let(:size)   { 3 }

    it 'should be registerd' do
      expect(subject.size).to eq size
    end
  end

  describe '#hello' do
    before { size.times { client.hello { puts 'hello' } } }
    subject { client.instance_variable_get(:@listeners)[:hello] }
    let(:regexp) { /test/ }
    let(:size)   { 2 }

    it 'should be registerd' do
      expect(subject.size).to eq size
    end
  end

  describe '#start' do
    before do
      client.hello { 'hello' }
      client.hear(/hear/) { 'hear' }
      # HACK: slack-api is used EventMachine.
      # This code is stopped EventMachine after connected when test.
      Thread.new do
        sleep 5
        EventMachine.add_timer 1 do
          EventMachine.stop_event_loop
        end
      end
    end

    subject { client.start }
    it { expect { subject }.not_to raise_error }
  end
end
