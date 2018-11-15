# ExDataHoover

This package exposes a simple API to implement event sourcing.

Please refer to `lib/ex_data_hoover/bag/simple.ex` for an example.

## Installation

Update you mix file:

``` elixir

  defp deps do
    [
      {:ex_data_hoover, git: "https://github.com/jobteaser/ex_data_hoover.git"}
    ]
  end

```

And then execute:

```
  $ mix deps.get
```

## Configuration

First, you have to start a `Nozzle`:

``` elixir

  ExDataHoover.Nozzle.start_link(
    :sign_in, #name
    ExDataHoover.Bag.Simple, #Your Bag
    fn(x) -> x end #traits anonymous function
  )
```

The traits function is used to properly qualify your users. If you do not need
this, you can skip the configuration.

And you can then start to send events:

``` elixir
  event_payload = %{
    field_1: 'foo',
    field_2: { bar: 'baz' }
  }
  ExDataHoover.Nozzle.absorb(:sign_in,
    trackee: user,
    event: "sign_in attempt",
    props: %{timestamps: NaiveDateTime.utc_now()}
  )
```

## Development

Run `mix test` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/jobteaser/ex_data_hoover.


## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_data_hoover](https://hexdocs.pm/ex_data_hoover).

