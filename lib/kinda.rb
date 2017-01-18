require "kinda/version"

class Kinda < Module
  ConstraintError = Class.new(ArgumentError)

  class << self
    def module
      new
    end
  end

  def initialize
    Object.include(Kinda::Types)
  end

  def included(host)
    host.extend(ClassMethods)
  end

  module ClassMethods
    def [](*klasses)
      klasses = klasses.flatten.map { |k| convert_custom_klass(k) }.flatten

      unless klasses.all? { |k| k.kind_of?(Class) }
        raise ArgumentError.new("expected Class but given #{klasses.map(&:class).inspect}")
      end

      lambda do |obj|
        if klasses.none? { |k| obj.kind_of?(k) }
          raise ConstraintError.new("expected #{klasses.inspect} but given #{obj.class}")
        end

        obj
      end
    end

    private

    def convert_custom_klass(klass)
      return klass unless klass < Kinda::Types::Custom

      case klass.name
      when 'Kinda::Types::Nil'
        NilClass
      when 'Kinda::Types::True'
        TrueClass
      when 'Kinda::Types::False'
        FalseClass
      when 'Kinda::Types::Bool'
        [TrueClass, FalseClass]
      else
        klass
      end
    end
  end
  private_constant(:ClassMethods)

  module Types
    Custom = Class.new

    PREFIX = "__KINDA__"
    Nil   = Class.new(Custom) unless defined?(Object::Nil)
    True  = Class.new(Custom) unless defined?(Object::True)
    False = Class.new(Custom) unless defined?(Object::False)
    Bool  = Class.new(Custom) unless defined?(Object::Bool)
  end

end
