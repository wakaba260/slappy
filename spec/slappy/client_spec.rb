require 'spec_helper'

describe Slappy::Client do
  let(:client) { Slappy::Client.new }
  let(:realtime) { ::Slack::RealTime::Client.new(url) }
  let(:url)      { nil }

  before do
    # There classes in slack-api (Stop connection for slack)
    allow_any_instance_of(::Slack::API).to receive(:realtime).and_return(realtime)
    allow_any_instance_of(::Slack::RealTime::Client).to receive(:start).and_return(nil)
  end

  describe '#hear' do
    before { size.times { client.hear(regexp) { puts 'hear' } } }
    subject { client.instance_variable_get(:@callbacks)[:message] }
    let(:regexp) { /test/ }
    let(:size)   { 3 }

    it 'should be registerd' do
      expect(subject.size).to eq size
    end
  end

  describe '#respond' do
    before do
      Slappy.configure { |config| config.robot.botname = botname }
      allow_any_instance_of(Slappy::Event).to receive(:channel).and_return(channel)
      allow_any_instance_of(Slappy::Listener::TextListener).to receive(:valid?).and_return(true)
      allow_any_instance_of(Slappy::Listener::TextListener).to receive(:target?).and_return(true)
      client.respond pattern, options, &block
    end

    subject { client.instance_variable_get(:@callbacks)[:message] }
    let(:pattern) { 'test' }
    let(:options) { Hash.new }
    let(:block)   { proc { print 'respond' } }
    let(:event)   { Slappy::Event.new text: "#{botname} #{pattern}", channel: 'slappy' }
    let(:botname) { 'slappy' }
    let(:channel) { Slappy::SlackAPI::Channel.new id: '12345', name: 'slappy' }

    it 'should be registerd' do
      expect(subject.size).to eq 1
    end

    context 'when match pattern' do
      it 'should be callback call' do
        expect { subject.first.call(event) }.to output('respond').to_stdout
      end
    end

    context 'when not match pattern' do
      let(:event) { Slappy::Event.new text: pattern, channel: 'slappy' }

      it 'should not be callback call' do
        expect { subject.first.call(event) }.to output(nil).to_stdout
      end
    end
  end

  describe '#goodnight' do
    subject { client.start }

    before do
      allow_any_instance_of(::Slack::RealTime::Client).to receive(:start).and_raise(StandardError)
      allow(STDERR).to receive(:puts).and_return(nil)
      client.goodnight { print 'goodnight' }
    end

    context 'when stop_with_error is true' do
      it { expect { subject }.to raise_error(SystemExit).and output('goodnight').to_stdout }
    end

    context 'when stop_with_error is false' do
      before { Slappy.configure { |config| config.stop_with_error = false } }
      it { expect { subject }.not_to raise_error }
      it { expect { subject }.to output('goodnight').to_stdout }
    end
  end

  describe '#hello' do
    before { size.times { client.hello { puts 'hello' } } }
    subject { client.instance_variable_get(:@callbacks)[:hello] }
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
    end

    subject { client.start }
    it { expect { subject }.not_to raise_error }
  end

  describe '#schedule' do
    subject { client.schedule(pattern, options) { nil } }
    let(:pattern) { '* * * * *' }
    let(:options) { Hash.new }
    it { expect { subject }.not_to raise_error }
  end

  describe '#config' do
    subject { client.send :config }
    it { is_expected.to be_instance_of Slappy::Configuration }
  end
end
