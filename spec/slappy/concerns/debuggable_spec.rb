require 'spec_helper'

describe Slappy::Debuggable do
  class Test
    include Slappy::Debuggable
  end

  let(:test_class) { Test.new }

  describe 'Debug.log' do
    before do
      Slappy.logger.instance_eval do
        def debug(msg)
          puts msg
        end
      end
    end
    subject { Test::Debug.log message }

    let(:message) { 'message test' }
    let(:result) { "[#{test_class.class.name}] #{message}\n" }

    it { expect { subject }.to output(result).to_stdout }
  end
end
