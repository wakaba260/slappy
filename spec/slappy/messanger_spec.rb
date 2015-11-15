require 'spec_helper'

describe Slappy::Messanger do
  before { allow(Slack).to receive(:chat_postMessage).and_return(nil) }
  let(:messanger) { described_class.new options }
  let(:options)   { { channel: channel } }
  let(:id)        { '12345' }

  describe '#message' do
    subject { messanger.message }
    let(:group_class)   { Slappy::SlackAPI::Group }
    let(:channel_class) { Slappy::SlackAPI::Channel }
    let(:direct_class)  { Slappy::SlackAPI::Direct }

    context 'when SlackAPI::Channel given' do
      let(:channel) { Slappy::SlackAPI::Channel.new data }
      let(:data)    { { id: id, name: 'test', text: 'text' } }

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
  end
end
