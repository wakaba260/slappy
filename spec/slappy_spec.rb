require 'spec_helper'

describe Slappy do
  describe '.configuration' do
    context 'when block not given' do
      subject { Slappy.configure }
      it { is_expected.to be_instance_of Slappy::Configuration }
    end

    context 'when block given' do
      before do
        Slappy.configure do |config|
          config.token = token
        end
      end
      subject { Slappy.configuration }
      let(:token) { 'slappy' }

      it { expect(Slappy.configuration.token).to eq token }
    end
  end

  describe '.method_missing' do
    subject { Slappy.hello { puts 'hello' } }
    it { expect { subject }.not_to raise_error }
  end

  describe '.respond_to?' do
    subject { Slappy.respond_to? :hello }
    it { expect { subject }.not_to raise_error }
  end
end
