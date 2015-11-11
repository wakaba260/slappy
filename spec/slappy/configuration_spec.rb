require 'spec_helper'

describe Slappy::Configuration do
  let(:configuration) { Slappy::Configuration.new }

  describe '.logger' do
    subject { configuration.logger }

    context 'when default logger' do
      let(:default_log_level) { Logger::INFO }

      it 'should set Logger::INFO to level' do
        expect(subject.level).to eq default_log_level
      end

      it { is_expected.to be_instance_of Logger }
    end

    context 'when logger specify' do
      before { configuration.logger = dummy_logger }
      let(:dummy_logger) { double('logger') }

      it 'should eq specify logger' do
        is_expected.to eq dummy_logger
      end
    end
  end
end
