require 'spec_helper'

describe Slappy::Listener::TextListener do
  let(:listener) { described_class.new(pattern, callback) }
  let(:pattern)  { /test/ }
  let(:callback) { proc { result } }
  let(:result)   { 'test' }

  describe '#pattern' do
    subject { listener.pattern }
    let(:regexp) { /^test/ }

    context 'when regexp given' do
      let(:pattern) { /^test/ }

      it 'should be return regexp' do
        is_expected.to eq regexp
      end
    end

    context 'when string given' do
      let(:pattern) { '^test' }

      it 'should be return regexp' do
        is_expected.to eq regexp
      end
    end
  end
end
