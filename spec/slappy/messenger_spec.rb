require 'spec_helper'

describe Slappy::Messenger do
  before { allow(Slack).to receive(:chat_postMessage).and_return(response) }
  let(:response)  { { 'ok' => true } }
  let(:messenger) { described_class.new options }
  let(:options)   { { channel: channel } }
  let(:channel) { Slappy::SlackAPI::Channel.new data }
  let(:data)    { { id: id, name: 'test', text: 'text' } }
  let(:id)        { '12345' }

  describe '#message' do
    subject { messenger.message }
    let(:group_class)   { Slappy::SlackAPI::Group }
    let(:channel_class) { Slappy::SlackAPI::Channel }
    let(:direct_class)  { Slappy::SlackAPI::Direct }

    context 'when SlackAPI::Channel given' do
      it { expect { subject }.not_to raise_error }
    end

    context 'when group id given' do
      before do
        allow(group_class).to receive(:list).and_return([result])
        allow(channel_class).to receive(:list).and_return([])
        allow(direct_class).to receive(:list).and_return([])
      end

      let(:result)  { group_class.new id: id }
      let(:channel) { id }

      it { expect { subject }.not_to raise_error }
    end

    context 'when response expect error' do
      let(:response) { { 'ok' => false } }
      it { expect { subject }.to raise_error Slappy::SlackAPI::SlackError }
    end
  end
end
