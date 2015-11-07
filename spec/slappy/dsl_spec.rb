require 'spec_helper'
require 'slappy/dsl'

describe Slappy::DSL do
  describe 'delegators' do
    context 'when delegated method' do
      subject { respond_to? :hello }
      it { is_expected.to be_truthy }
    end

    context 'when not delegated method' do
      subject { respond_to? :undefined_method }
      it { is_expected.to be_falsy }
    end

    context 'when add receiver call' do
      subject { Slappy }
      it { expect { subject.hello }.not_to raise_error }
      it { expect(subject.respond_to? :hello).to be_truthy }
    end
  end
end
