require 'spec_helper'

describe Slappy::Commands::Generator do
  let(:generator_command) { Slappy::Commands::Generator.new }
  describe '#template_script_path' do
    subject { FileTest.file? file_path }
    let(:file_path) { generator_command.send :template_script_path }
    it { is_expected.to be_truthy }
  end

  describe '#config_file_path' do
    subject { FileTest.file? file_path }
    let(:file_path) { generator_command.send :config_file_path }
    it { is_expected.to be_truthy }
  end
end
