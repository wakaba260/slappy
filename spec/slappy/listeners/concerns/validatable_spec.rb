require 'spec_helper'
require 'active_support/core_ext/numeric/time'
require 'timecop'

describe Slappy::Listener::Validatable do
  class SpecListener
    include Slappy::Listener::Validatable

    def initialize(pattern)
      self.pattern = pattern
    end
  end

  let(:listener) { SpecListener.new(pattern) }
  let(:pattern)  { 'test' }
  let(:event)    { Slappy::Event.new(data) }
  let(:data)     { { 'spec' => 'test', 'ts' => data_ts.to_f.to_s } }
  let(:data_ts)  { 1.hours.since }
  let(:now)      { Time.now }

  before do
    Timecop.freeze(Time.now)
    allow_any_instance_of(Slappy::Client).to receive(:start_time).and_return(now)
  end

  describe '#call' do
    subject { listener.valid?(event) }

    context 'when match pattern' do
      it 'should be execute' do
        is_expected.to be_truthy
      end
    end

    context 'when not match pattern' do
      let(:data) { { text: 'hoge' } }

      it 'should not be execute' do
        is_expected.to be_falsey
      end
    end

    context 'when before start_time called' do
      let(:data_ts) { 1.hours.ago }

      it 'should not be execute' do
        is_expected.to be_falsey
      end
    end
  end
end
