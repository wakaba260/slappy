require 'spec_helper'

describe Slappy::Listener do
  let(:listener) { Slappy::Listener.new(pattern, callback) }
  let(:pattern)  { /test/ }
  let(:callback) { proc { result } }
  let(:result)   { 'test' }
  let(:event)    { Slappy::Event.new(data, pattern) }
  let(:data)     { { 'text' => 'test' } }

  describe '#pattern' do
    let(:regexp) { /^test/ }

    context 'when regexp given' do
      subject { listener.pattern }
      let(:pattern) { /^test/ }

      it 'should be return regexp' do
        is_expected.to eq regexp
      end
    end

    context 'when string given' do
      subject { listener.pattern }
      let(:pattern) { '^test' }

      it 'should be return regexp' do
        is_expected.to eq regexp
      end
    end
  end

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
