defmodule ExDataHoover.Bag do
  @moduledoc """
  Specifies callbacks for custom Bags

  A bag is injected in a Nozzle and must be able to:

  - extract the trackee id
  - wrap trackee, event, properties

  See ExDataHoover.Bag.Simple to see an example
  """
  @callback trackee_id(any) :: {:ok, any} | {:error, String.t()}
  @callback wrap(
              trackee_id: any,
              trackee: any,
              traits: map,
              event: String.t(),
              properties: map
            ) :: {:ok, any} | {:error, String.t()}
end
