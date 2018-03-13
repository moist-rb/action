# frozen_string_literal: true

require 'fear/rspec'
require 'spec_helper'

RSpec.describe Moist::Action do
  context 'actions without defined params' do
    subject { action.new.(foo: 'bar') }

    let(:action) do
      Class.new do
        include Moist::Action

        def perform(params)
          params
        end
      end
    end

    it 'strip out all given params' do
      is_expected.to be_right_of({})
    end
  end

  context 'actions with required params' do
    let(:action) do
      Class.new do
        include Moist::Action

        params do
          required(:name).filled(:str?)
        end

        def perform(params)
          params
        end
      end
    end

    context 'required param given' do
      subject { action.new.(name: 'Carl', surname: 'Lazlo') }

      it 'keep this param and strip out other params' do
        is_expected.to be_right_of(name: 'Carl')
      end
    end

    context 'required param is invalid' do
      subject { action.new.(name: '') }

      it 'keep this param and strip out other params' do
        is_expected.to be_left_of(name: ['must be filled'])
      end
    end
  end
end
