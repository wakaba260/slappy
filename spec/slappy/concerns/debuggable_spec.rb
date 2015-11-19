require 'spec_helper'

describe Slappy::Debuggable do
  class Test1
    include Slappy::Debuggable
  end

  class Test2
    include Slappy::Debuggable
  end

  let(:test_class1) { Test1.new }
  let(:test_class2) { Test2.new }

  describe 'Debug.log' do
    before do
      Slappy.logger.instance_eval do
        def debug(msg)
          puts msg
        end
      end
    end
    let(:message) { 'message test' }
    let(:result1) { "[#{test_class1.class.name}] #{message}\n" }
    let(:result2) { "[#{test_class2.class.name}] #{message}\n" }

    it { expect { Test1::Debug.log message }.to output(result1).to_stdout }
    it { expect { Test2::Debug.log message }.to output(result2).to_stdout }
  end
end
