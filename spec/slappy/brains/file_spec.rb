require 'spec_helper'
require 'fileutils'

describe Slappy::Brain::File do
  before(:each) { ::FileUtils.touch(path) }
  after(:each) do
    brain.instance_variable_get(:@thread).kill
    ::FileUtils.rm(path)
  end

  let(:brain) { described_class.new path }
  let(:path)  { ::File.expand_path '../../../files/dummy.dump', __FILE__ }
  let(:key)   { :key }
  let(:value) { :value }
  let(:data)  { { key1: :value1, key2: :value2 } }

  describe '#set' do
    subject { brain.set key, value }

    it { expect { subject }.not_to raise_error }
  end

  describe '#get' do
    before  { brain.set key, value }
    subject { brain.get key }

    it { expect { subject }.not_to raise_error }
    it { is_expected.to eq value }
  end

  describe '#read' do
    before  { ::File.open(path, 'w') { |io| Marshal.dump(data, io) } }
    subject { brain.send :read }

    it { expect { subject }.not_to raise_error }
    it { is_expected.to eq data }
  end

  describe '#write' do
    before  { brain.instance_variable_set(:@data, data) }
    subject { brain.send :write }

    it { expect { subject }.not_to raise_error }

    context 'when large data given' do
      before do
        100_000.times do |n|
          data[n] = n
        end
      end

      let(:thread) { brain.instance_variable_get(:@thread) }

      it { expect { subject }.not_to raise_error }
    end
  end
end
