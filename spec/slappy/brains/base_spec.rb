require 'spec_helper'

describe Slappy::Brain::Base do
  let(:brain) { described_class.new }
  let(:key)   { :key }
  let(:value) { :value }

  describe '#set' do
    subject { brain.set key, value }
    it { expect { subject }.not_to raise_error }
  end

  describe '#get' do
    before { brain.set key, value }
    subject { brain.get key }
    it { is_expected.to eq value }
  end
end
