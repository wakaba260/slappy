require 'spec_helper'

describe Slappy::SlackAPI::Findable do
  class Group
    include Slappy::SlackAPI::Findable
    self.monitor_event = 'group_open'
  end

  before do
    allow_any_instance_of(Slappy::Event).to receive(:channel).and_return(Hashie::Mash.new(data))
    allow(Slack).to receive(:groups_list).and_return(groups_list)
  end
  let(:test_class) { Group }
  let(:type) { 'group_open' }
  let(:groups_list) { { 'groups' => [data] } }
  let(:data) { { id: id, name: name, type: type, ts: Time.now } }
  let(:id)   { '12345' }
  let(:name) { 'test' }

  describe '#list' do
    subject { test_class.list }
    it { expect { subject }.not_to raise_error }

    context 'when monitor_event call' do
      before do
        test_class.list
        listener = Slappy::Listener::TypeListener
        allow_any_instance_of(listener).to receive(:valid?).and_return(true)
        allow_any_instance_of(listener).to receive(:target?).and_return(true)
        Slappy.client.instance_variable_get(:@callbacks)[:group_open].each do |callback|
          callback.call(event)
        end
      end

      subject { test_class.instance_variable_get(:@list) }
      let(:event) { Slappy::Event.new(data) }

      it { is_expected.to be_nil }
    end
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
