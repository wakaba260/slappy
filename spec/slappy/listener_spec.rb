require 'spec_helper'
require 'active_support/core_ext/numeric/time'
require 'timecop'

describe Slappy::Listener do
  let(:listener) { Slappy::Listener.new(pattern, callback) }
  let(:pattern)  { /test/ }
  let(:callback) { proc { result } }
  let(:result)   { 'test' }
  let(:event)    { Slappy::Event.new(data) }
  let(:data)     { { 'text' => 'test', 'ts' => data_ts.to_f.to_s } }
  let(:data_ts)  { 1.hours.since }
  let(:now)      { Time.now }

  before do
    Timecop.freeze(Time.now)
    allow_any_instance_of(Slappy::Client).to receive(:start_time).and_return(now)
  end

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

  describe '#call' do
    subject { listener.call(event) }

    context 'when match pattern' do
      it 'should be execute' do
        is_expected.to eq result
      end
    end

    context 'when not match pattern' do
      let(:data) { { text: 'hoge' } }

      it 'should not be execute' do
        is_expected.to eq nil
      end
    end

    context 'when before start_time called' do
      let(:data_ts) { 1.hours.ago }

      it 'should not be execute' do
        is_expected.to eq nil
      end
    end
  end
end
