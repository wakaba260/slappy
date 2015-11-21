require 'spec_helper'

describe Slappy::Listener::Targettable do
  include described_class
  let!(:channel_class) { Slappy::SlackAPI::Channel }
  let!(:user_class)    { Slappy::SlackAPI::User    }
  let!(:direct_class)  { Slappy::SlackAPI::Direct  }
  let!(:group_class)   { Slappy::SlackAPI::Group   }

  let(:target_channel)      { channel_class.new id: target_channel_id, name: target_channel_name }
  let(:target_channel_id)   { 'target_channel_id' }
  let(:target_channel_name) { 'target_channel'    }

  let(:target_user)         { user_class.new id: target_user_id, name: target_user_name }
  let(:target_user_id)      { 'target_user_id' }
  let(:target_user_name)    { 'target_user'    }

  let(:target_group)        { group_class.new id: target_group_id, name: target_group_name }
  let(:target_group_id)     { 'target_group_id' }
  let(:target_group_name)   { 'target_group'    }

  let(:target_direct)       { direct_class.new id: target_direct_id, name: target_direct_name }
  let(:target_direct_id)    { 'target_direct_id' }
  let(:target_direct_name)  { 'target_direct'    }

  let(:other_channel)      { channel_class.new id: other_channel_id, name: other_channel_name }
  let(:other_channel_id)   { 'other_channel_id' }
  let(:other_channel_name) { 'other_channel'    }

  let(:other_group)        { group_class.new id: other_group_id, name: other_group_name }
  let(:other_group_id)     { 'other_group_id' }
  let(:other_group_name)   { 'other_group'    }

  let(:other_user)         { user_class.new id: other_user_id, name: other_user_name }
  let(:other_user_id)      { 'other_user_id' }
  let(:other_user_name)    { 'other_user'    }

  let(:other_direct)       { direct_class.new id: other_direct_id, name: other_direct_name }
  let(:other_direct_id)    { 'other_direct_id' }
  let(:other_direct_name)  { 'other_direct'    }

  let(:event) { Slappy::Event.new data }

  describe '#restrict?' do
    before do
      channel_class.instance_variable_set :@list, [target_channel, other_channel]
      user_class.instance_variable_set :@list, [target_user, other_user]
      group_class.instance_variable_set :@list, [target_group, other_group]
      direct_class.instance_variable_set :@list, [target_direct, other_direct]
    end

    subject { target?(event) }

    context 'when no restrict' do
      context 'target channel given' do
        let(:data) { { channel: target_channel_id, user: target_user_id } }
        it { is_expected.to be_truthy }
      end

      context 'other channel given' do
        let(:data) { { channel: other_channel_id, user: other_user_id } }
        it { is_expected.to be_truthy }
      end
    end

    context 'when single restrict' do
      context 'target channel given' do
        before { target.channel = '#' + target_channel_name }
        let(:data) { { channel: target_channel_id, user: target_user_id } }
        it { is_expected.to be_truthy }
      end

      context 'out of restrict channel given' do
        before { target.channel = '#' + target_channel_name }
        let(:data) { { channel: other_channel_id, user: target_user_id } }
        it { is_expected.to be_falsey }
      end

      context 'target group given' do
        before { target.channel = target_group_name }
        let(:data) { { channel: target_group_id, user: target_user_id } }
        it { is_expected.to be_truthy }
      end

      context 'out of target group given' do
        before { target.channel = target_group_name }
        let(:data) { { channel: other_group_id, user: target_user_id } }
        it { is_expected.to be_falsey }
      end

      context 'target user given' do
        before { target.user = '@' + target_user_name }
        let(:data) { { channel: target_channel_id, user: target_user_id } }
        it { is_expected.to be_truthy }
      end

      context 'out of target user given' do
        before { target.user = '@' + target_user_name }
        let(:data) { { channel: target_channel_id, user: other_user_id } }
        it { is_expected.to be_falsey }
      end
    end

    context 'when plural restrict' do
      before do
        target.channel = '#' + target_channel_name
        target.user = '@' + target_user_name
      end

      context 'when only target_user given' do
        let(:data) { { channel: other_channel_id, user: target_user_id } }
        it { is_expected.to be_falsey }
      end

      context 'when only target_channel given' do
        let(:data) { { channel: target_channel_id, user: other_user_id } }
        it { is_expected.to be_falsey }
      end

      context 'when target_channel and target_user given' do
        let(:data) { { channel: target_channel_id, user: target_user_id } }
        it { is_expected.to be_truthy }
      end

      context 'when target_channel and other_user given' do
        let(:data) { { channel: target_channel_id, user: other_user_id } }
        it { is_expected.to be_falsey }
      end

      context 'when other_channel and target_user given' do
        let(:data) { { channel: other_channel_id, user: target_user_id } }
        it { is_expected.to be_falsey }
      end
    end
  end

  describe 'Target' do
    let(:target) { described_class::Target.new }

    describe '#channel_list' do
      before { target.channel = '#' + target_channel_name }
      subject { target.channel_list }
      it { is_expected.to eq [target_channel] }
    end

    describe '#user_list' do
      before { target.user = '@' + target_user_name }
      subject { target.user_list }
      it { is_expected.to eq [target_user] }
    end
  end
end
