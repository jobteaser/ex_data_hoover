defmodule ExDataHoover.Bag.Simple do
  @behaviour ExDataHoover.Bag

  def trackee_id(trackee) do
    case Map.get(trackee, "id") do
      nil -> {:error, "There is no id into trackee"}
      value -> {:ok, value}
    end
  end

  def wrap(payload) do
    {:ok, Enum.into(payload, %{})}
  end
end
