require 'spec_helper'
require 'bigdecimal'

describe Kinda do
  it 'has a version number' do
    expect(Kinda::VERSION).not_to be nil
  end

  before do
    module Type
      include Kinda.module
    end
  end

  describe '#[]' do
    it 'accepts a class' do
      expect { Type[Float] }.to_not raise_error
    end

    it 'only accepts a class' do
      expect { Type[1] }.to raise_error(ArgumentError)
    end

    it 'returns a callable' do
      expect(Type[Float]).to respond_to(:call)
    end

    it 'can take #to_proc' do
      expect(Type[Float]).to respond_to(:to_proc)
    end
  end

  describe 'callable' do
    it 'returns the input for correct types' do
      expect(Type[Float].call(1.0)).to eq(1.0)
    end

    it 'raises an error for bad types' do
      expect { Type[Float].call(1) }.to raise_error(Kinda::ConstraintError)
    end
  end

  describe 'types' do
    it 'has a Nil type' do
      expect(Type[Nil].call(nil)).to eq(nil)
    end

    it 'has a True type' do
      expect(Type[True].call(true)).to eq(true)
    end

    it 'has a False type' do
      expect(Type[False].call(false)).to eq(false)
    end

    it 'has a Bool type' do
      expect(Type[Bool].call(true)).to eq(true)
      expect(Type[Bool].call(false)).to eq(false)
    end

    it 'can define new types' do
      MaybeDecimal = [Nil, BigDecimal, Float]

      expect(Type[MaybeDecimal].call(nil)).to eq(nil)
      expect(Type[MaybeDecimal].call(1.0)).to eq(1.0)
      expect(Type[MaybeDecimal].call(BigDecimal.new('1.0'))).to eq(BigDecimal.new('1.0'))
      expect { Type[MaybeDecimal].call(1) }.to raise_error(ArgumentError)
    end
  end

end
