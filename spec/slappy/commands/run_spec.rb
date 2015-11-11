require 'spec_helper'

include Slappy

describe Slappy::Commands::Run do
  let(:run_command) { Commands::Run.new }
  let(:current_dir) { File.dirname(__FILE__) }
  let(:load_dir)  { File.expand_path '../../files/', current_dir }
  let(:error_class) { Commands::Run::InvalidPathError }
  let(:file_path) { File.expand_path file_name, load_dir }
  let(:file_name) { 'dummy.rb' }

  before do
    Slappy.configuration.scripts_dir_path = load_dir
    Slappy.configuration.lib_dir_path = load_dir
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

  shared_examples_for 'load_dir' do
    subject { run_command.send load_dir_method }

    context 'when exist path given' do
      it { expect { subject }.not_to raise_error }
    end

    context 'when not exist path given' do
      before { Slappy.configuration.send config_dir_method, not_exist_dir }
      it "should raise error and 'direcotory not_exist_dir not found' message" do
        expect { subject }.to raise_error error_class, "directory #{not_exist_dir} not found"
      end
    end
  end

  describe '#load_scripts' do
    let(:load_dir_method) { :load_scripts }
    let(:config_dir_method) { :scripts_dir_path= }
    let(:not_exist_dir) { File.expand_path '../../notfound/', current_dir }
    it_behaves_like 'load_dir'
  end

  describe '#load_libs' do
    let(:load_dir_method) { :load_libs }
    let(:config_dir_method) { :lib_dir_path= }
    let(:not_exist_dir) { File.expand_path '../../notfound/', current_dir }
    it_behaves_like 'load_dir'
  end
end
