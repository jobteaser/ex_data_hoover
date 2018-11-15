defmodule ExDataHoover.Bag.SimpleTest do
  use ExUnit.Case
  doctest ExDataHoover.Bag.Simple

  describe "trackee/1" do
    test "returns the id" do
      assert ExDataHoover.Bag.Simple.trackee_id(%{"id" => "1"}) == {:ok, "1"}
    end
  end

  describe "wrap/1" do
    test "wrap the whole informations" do
      assert ExDataHoover.Bag.Simple.wrap(event: "foo_event", trackee_id: "1") ==
               {:ok, %{event: "foo_event", trackee_id: "1"}}
    end
  end
end
