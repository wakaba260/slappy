require 'spec_helper'

describe Slappy::Schedule do
  let(:schedule) { described_class.new }
  let(:pattern)  { '* * * * *' }
  let(:id)       { 'test' }

  describe '#register' do
    subject { schedule.instance_variable_get(:@schedule_list).size }
    before do
      @before_thread_count = Thread.list.size
      schedule.register(pattern, id: id) { nil }
    end

    let(:after_thread_count) { @before_thread_count + 1 }

    it 'should be registered' do
      is_expected.to eq 1
    end

    it 'should be thread all running' do
      expect(Thread.list.map(&:status)).to all(be_truthy)
    end

    after { schedule.remove(id) }
  end

  describe '#remove' do
    subject { schedule.instance_variable_get(:@schedule_list).size }

    before do
      schedule.register(pattern, id: id) { nil }
      schedule.remove(id)
    end

    it 'should be removed' do
      is_expected.to eq 0
    end
  end

  describe '#generate_id' do
    subject { schedule.send :generate_id }
    let(:default) { described_class::DEFAULT_MAX_THREAD }
    let(:figure)  { Math.log10(default).to_i + 1 }
    it { expect(subject.size).to eq figure }
  end
end
