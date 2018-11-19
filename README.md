# ExDataHoover

This package exposes a simple API to implement event sourcing.

## Installation

Update you mix file:

``` elixir

  defp deps do
    [
      {:ex_data_hoover, "~> 0.1.0"}
    ]
  end

```

And then execute:

```
  $ mix deps.get
```

## Configuration

First, you have to start a `Nozzle` Genserver:

``` elixir

  ExDataHoover.Nozzle.start_link(
    :sign_in, #name
    ExDataHoover.Bag.Simple, #Your Bag
    fn(x) -> x end #traits anonymous function
  )
```

- Name: it's the Nozzle name.
- Bag module: the bag is responsible for formatting and sending the event.
- The traits function: is used to properly qualify your users(that means you could use it to extract
meaningfull informations from the `trackee`). If you do not need this, you can skip the
configuration.

And you can then send an event by calling the `absorb` function:


``` elixir
  ExDataHoover.Nozzle.absorb(:sign_in,
    trackee: user,
    event: "sign_in attempt",
    props: %{timestamps: NaiveDateTime.utc_now()}
  )
```

- Nozzle name: the same you used to start your Nozzle.
- Trackee: It could be whatever you want, `ExDataHoover.Bag.Simple` considers it as a `map` and
try to extract the value of the `"id"` key.
- event: event name.
- props: a map containing your payload.


Some notes about the `bag`

Please refer to `lib/ex_data_hoover/bag/simple.ex` for a bag example.

A bag has to omplement 2 functions:

- `trackee_id`: it takes the trackee and tries to extract and return an unique id from it
- `wrap`: it takes the `props` and returns `{:ok, any()`. You can format and send the payload to
your storage in this function.

## Development

Run `mix test` to run the tests.
Run `mix dialyzer` to check typespecs.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/jobteaser/ex_data_hoover.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_data_hoover](https://hexdocs.pm/ex_data_hoover).
