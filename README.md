# Kinda

Super basic type checking functions in ruby.

## Usage

```
module Type
  include Kinda.module
end

Type[Float].call(1.0)
# => 1.0

Type[Float].call(1)
# => Kinda::ConstraintError: expected Float but given Fixnum
```

In addition to any normal Ruby class the following custom types are available.

* Nil
* True
* False
* Bool

```
Type[Bool].call(true)
# => true

Type[Bool].call(false)
# => false

Type[Bool].call(nil)
# => Kinda::ConstraintError: expected [TrueClass, FalseClass] but given NilClass
```

New types can also be defined in terms of existing types.

```
require 'bigdecimal'

Decimal = [BigDecimal, Float]

Type[Decimal].call(BigDecimal.new('1.0'))
# => #<BigDecimal:7fdd2c3aa9b0,'0.1E1',9(18)>

MaybeDecimal = [Nil, Decimal]

Type[MaybeDecimal].call(1.0)
# => 1.0

Type[MaybeDecimal].call(nil)
# => nil

Type[MaybeDecimal].call(1)
# => Kinda::ConstraintError: expected [NilClass, BigDecimal, Float] but given Fixnum
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sbscully/kinda.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

