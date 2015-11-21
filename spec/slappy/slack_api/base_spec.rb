require 'spec_helper'

describe Slappy::SlackAPI::Base do
  let(:base) { described_class.new id: id, name: name }
  let(:id)   { 'base_id' }
  let(:name) { 'base' }

  describe '#==' do
    subject { base == other }

    context 'when same id object given' do
      let(:other) { described_class.new id: id, name: name }
      it { is_expected.to be_truthy }
    end

    context 'when same name object given' do
      let(:other) { described_class.new id: 'other_id', name: name }
      it { is_expected.to be_falsey }
    end
  end
end
