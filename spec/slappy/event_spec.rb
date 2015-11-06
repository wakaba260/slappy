require 'spec_helper'

describe Slappy::Event do
  let(:event)   { Slappy::Event.new(data, pattern) }
  let(:pattern) { /test (.*)/ }
  let(:data) do
    {
      'type'     => 'message',
      'channel'  => 'C0D1TQL0L',
      'user'     => 'U04RNAV76',
      'text'     => 'this is test message',
      'ts'       => '1446695868.000046',
      'event_ts' => '1446695868.000046',
      'team'     => 'T029DFCEP'
    }
  end

  describe '#match_data' do
    subject { event.matches }
    let(:matcher) { data['text'].match pattern }
    it { is_expected.to eq matcher }
  end

  describe 'defined_method' do
    shared_examples_for 'check defined_method' do
      describe 'has method' do
        subject { event.respond_to? key }
        it 'should be respond' do
          is_expected.to be_truthy
        end
      end

      describe 'return value' do
        subject { event.send key }
        it 'should be correct' do
          is_expected.to eq return_value
        end
      end

      describe ''
    end

    context 'type' do
      let(:key) { 'type' }
      let(:return_value) { data['type'] }
      it_behaves_like 'check defined_method'
    end

    context 'text' do
      let(:key) { 'text' }
      let(:return_value) { data['text'] }
      it_behaves_like 'check defined_method'
    end

    context 'when text is nil' do
      subject { event.text }
      let(:event) { Slappy::Event.new(data_text_nil, pattern) }
      let(:data_text_nil) { data.reject { |k, _v| k == 'text' } }

      it { expect { subject }.not_to raise_error }
      it 'should return empty return value' do
        is_expected.to eq ''
      end
    end
  end
end
