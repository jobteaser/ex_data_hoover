defmodule ExDataHoover.Nozzle do
  @moduledoc """
  Nozzle exposes a public API around the concept of event sourcing.

  The `Nozzle` provides a basic server implementation that allows to absorb an event.

  You have the possibility to use your own `Bag` to implements what happened after the absortion.

  ## Example

  For example, the following nozzle will absorb an event to a simple bag:

      ExDataHoover.Nozzle.start_link(:simple_noozle, ExDataHoover.Bag.Simple)

      ExDataHoover.Nozzle.sync_absorb(
        :simple_noozle,
        trackee: %{"type" => "User", "id" => 1},
        event: "authenticated",
        props: %{"at" => "2018-11-14 10:00:00"}
      )

      #=> {:ok,
            %{
              event: "authenticated",
              properties: %{"at" => "2018-11-14 10:00:00"},
              trackee: %{"id" => 1, "type" => "User"},
              trackee_id: "6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b",
              traits: %{"id" => 1, "type" => "User"}
            }
          }
  """

  use GenServer

  # Public interface

  @doc """
  Starts a nozzle linked to the current process.

  Argument expected is bag. The bag has to include `ExDataHoover.Bag` as `@behaviour`.
  """
  @spec start_link(module, name: atom, traits: (... -> any)) :: {:ok, pid}
  def start_link(name \\ __MODULE__, bag, traits \\ & &1) do
    GenServer.start_link(__MODULE__, %{bag: bag, traits: traits}, name: name)
  end

  @doc """
  Absorb an `event`, `trackee`, and `props`.
  The implementation will call the `bag.wrap` under the hood.
  """
  @spec absorb(atom(), [{:event, any()} | {:props, any()} | {:trackee, any()}, ...]) :: :ok
  def absorb(name \\ __MODULE__, trackee: trackee, event: event, props: props)
      when is_atom(name) do
    GenServer.cast(name, {:absorb, trackee: trackee, event: event, props: props})
  end

  @doc """
  Absorb an `event`, `trackee`, and `props`.
  The call is made in a synchronized way.
  The implementation is identical as the `absorb function` but it will return
  the `bag.wrap` result.
  """
  @spec sync_absorb(atom, trackee: any, event: String.t(), props: map) ::
          {:ok, any} | {:error | any}
  def sync_absorb(name \\ __MODULE__, trackee: trackee, event: event, props: props) do
    GenServer.call(name, {:sync_absorb, trackee: trackee, event: event, props: props})
  end

  # GenServer implementation
  def init(state = %{bag: _bag}) do
    {:ok, state}
  end

  def handle_cast({:absorb, trackee: trackee, event: event, props: props}, state) do
    do_wrap(
      trackee: trackee,
      event: event,
      props: props,
      bag: state[:bag],
      traits: state[:traits]
    )

    {:noreply, state}
  end

  def handle_call({:sync_absorb, trackee: trackee, event: event, props: props}, _from, state) do
    case do_wrap(
           trackee: trackee,
           event: event,
           props: props,
           bag: state[:bag],
           traits: state[:traits]
         ) do
      {:ok, results} -> {:reply, {:ok, results}, state}
      {:error, results} -> {:reply, {:error, results}, state}
      error -> {:reply, {:error, error}, state}
    end
  end

  defp do_wrap(trackee: trackee, event: event, props: props, bag: bag, traits: traits) do
    case bag.trackee_id(trackee) do
      {:ok, trackee_id} ->
        bag.wrap(
          trackee_id: ExDataHoover.anonymize(trackee_id),
          trackee: trackee,
          traits: extract_traits(trackee, traits),
          event: event,
          properties: props
        )

      error ->
        error
    end
  end

  defp extract_traits(trackee, traits) do
    trackee
    |> traits.()
    |> Enum.filter(fn {_, v} -> v end)
    |> Enum.into(%{})
  end
end
