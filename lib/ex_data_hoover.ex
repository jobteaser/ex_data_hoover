defmodule ExDataHoover do
  @moduledoc """
  This package exposes a simple API to implement event sourcing.
  """

  @doc """
  Anonymizes the data.

  ## Example

  ExDataHoover.anonymize("foobar")
  #=> "c3ab8ff13720e8ad9047dd39466b3c8974e592c2fa383d4a3960714caef0c4f2"
  """
  @spec anonymize(String.t() | integer() | nil) :: String.t() :: nil
  def anonymize(nil), do: nil

  def anonymize(data) when is_bitstring(data) do
    :crypto.hash(:sha256, data) |> Base.encode16() |> String.downcase()
  end

  def anonymize(data) when is_integer(data) do
    :crypto.hash(:sha256, to_string(data)) |> Base.encode16() |> String.downcase()
  end
end
