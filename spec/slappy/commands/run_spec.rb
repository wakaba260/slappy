require 'spec_helper'

include Slappy

describe Slappy::Commands::Run do
  let(:run_command) { Commands::Run.new }
  let(:current_dir) { File.dirname(__FILE__) }
  let(:script_dir)  { File.expand_path '../../files/', current_dir }
  let(:error_class) { Commands::Run::InvalidPathError }
  let(:file_path) { File.expand_path file_name, script_dir }
  let(:file_name) { 'dummy.rb' }

  before do
    Slappy.configuration.scripts_dir_path = script_dir
    allow_any_instance_of(Configuration).to receive(:config_file_path).and_return(file_path)
    allow_any_instance_of(Client).to receive(:start).and_return(nil)
  end

  describe '#call' do
    subject { run_command.call }
    it { expect { subject }.not_to raise_error }
  end

  describe '#load_config' do
    subject { run_command.send :load_config }

    context 'when exist filepath given' do
      it { expect { subject }.not_to raise_error }
    end

    context 'when not exist filepath given' do
      let(:file_name) { 'not_exist.rb' }
      it 'should raise error and "file #{file} not found" message' do
        expect { subject }.to raise_error error_class, "file #{file_path} not found"
      end
    end
  end

  describe '#load_slappy_scripts' do
    subject { run_command.send :load_scripts }

    context 'when exist path given' do
      it { expect { subject }.not_to raise_error }
    end

    context 'when not exist path given' do
      let(:script_dir) { File.expand_path '../../notfound/', current_dir }
      it 'should raise error and "direcotory #{script_dir} not found" message' do
        expect { subject }.to raise_error error_class, "directory #{script_dir} not found"
      end
    end
  end
end
