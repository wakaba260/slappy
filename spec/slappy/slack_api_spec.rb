require 'spec_helper'

describe Slappy::SlackAPI do
  let(:channel_class) { Slappy::SlackAPI::Channel }
  let(:group_class)   { Slappy::SlackAPI::Group }
  let(:direct_class)  { Slappy::SlackAPI::Direct }
  let(:user_class)    { Slappy::SlackAPI::User }
  let(:target_channel)      { channel_class.new id: target_channel_id, name: target_channel_name }
  let(:target_channel_id)   { 1 }
  let(:target_channel_name) { 'target_channel' }

  let(:target_user)         { user_class.new id: target_user_id, name: target_user_name }
  let(:target_user_id)      { 2 }
  let(:target_user_name)    { 'target_user' }

  let(:target_group)        { group_class.new id: target_group_id, name: target_group_name }
  let(:target_group_id)     { 3 }
  let(:target_group_name)   { 'target_group' }

  let(:target_direct)       { direct_class.new id: target_direct_id, name: target_direct_name }
  let(:target_direct_id)    { 4 }
  let(:target_direct_name)  { 'target_direct' }

  before do
    channel_class.instance_variable_set :@list, [target_channel]
    user_class.instance_variable_set :@list, [target_user]
    group_class.instance_variable_set :@list, [target_group]
    direct_class.instance_variable_set :@list, [target_direct]
  end

  describe '.find' do
    subject { described_class.find value }

    context 'when channel given' do
      let(:value) { '#' + target_channel_name }
      it { is_expected.to eq target_channel }
    end

    context 'when group given' do
      let(:value) { target_group_name }
      it { is_expected.to eq target_group }
    end

    context 'when user given' do
      let(:value) { '@' + target_user_name }
      it { is_expected.to eq target_user }
    end
  end
end
