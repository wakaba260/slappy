require 'spec_helper'

describe SlackBot::Listener do
  let(:listener) { SlackBot::Listener.new(pattern, callback) }
  let(:pattern)  { /test/ }
  let(:callback) { proc { result } }
  let(:result)   { 'test' }
  let(:event)    { SlackBot::Event.new(data) }
  let(:data)     { { 'text' => 'test' } }

  describe '#call' do
    context 'when match pattern' do
      subject { listener.call(event) }

      it 'should be execute' do
        is_expected.to eq result
      end
    end

    context 'when not match pattern' do
      subject { listener.call(event) }
      let(:data) { { text: 'hoge' } }

      it 'should not be execute' do
        is_expected.to eq nil
      end
    end
  end
end
