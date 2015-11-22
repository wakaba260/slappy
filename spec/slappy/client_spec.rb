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

  describe '#goodnight' do
    before do
      allow_any_instance_of(::Slack::RealTime::Client).to receive(:start).and_raise(StandardError)
      allow(STDERR).to receive(:puts).and_return(nil)
      client.goodnight { print 'goodnight' }
    end
    subject { client.start }
    it { expect { subject }.to raise_error(SystemExit).and output('goodnight').to_stdout }
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
