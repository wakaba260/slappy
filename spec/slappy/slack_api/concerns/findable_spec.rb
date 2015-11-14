require 'spec_helper'

describe Slappy::SlackAPI::Findable do
  class Group
    include Slappy::SlackAPI::Findable
  end

  before { allow(Slack).to receive(:groups_list).and_return(data) }
  let(:test_class) { Group }
  let(:data) { { 'groups' => [{ id: id, name: name }] } }
  let(:id)   { '12345' }
  let(:name) { 'test' }

  describe '#list' do
    subject { test_class.list }
    it { expect { subject }.not_to raise_error }
  end

  describe '#find' do
    context 'when id given' do
      subject { test_class.find id }

      it 'should return test class' do
        expect(subject.name).to eq name
      end
    end

    context 'when name given' do
      subject { test_class.find name: name }

      it 'should return test class' do
        expect(subject.id).to eq id
      end
    end
  end
end
