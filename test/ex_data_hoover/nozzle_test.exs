defmodule ExDataHoover.NozzleTest do
  use ExUnit.Case
  doctest ExDataHoover.Nozzle

  describe "start_link/1" do
    test "returns a pid" do
      {:ok, pid} = ExDataHoover.Nozzle.start_link(GoodProvider)
      assert is_pid(pid)
    end
  end

  describe "absorb/2" do
    test "it works with a valid provider" do
      ExDataHoover.Nozzle.start_link(GoodProvider)

      assert :ok =
               ExDataHoover.Nozzle.absorb(
                 trackee: %{"id" => 1},
                 event: "foo event",
                 props: %{"test" => "test"}
               )
    end
  end

  describe "sync_absorb/2" do
    test "it works with a valid provider" do
      ExDataHoover.Nozzle.start_link(GoodProvider)

      assert {:ok, "Done"} =
               ExDataHoover.Nozzle.sync_absorb(
                 trackee: %{id: 1},
                 event: "foo event",
                 props: %{"test" => "test"}
               )
    end

    @tag :capture_log
    test "it raises an error if wrap function is not defined in the provider" do
      {:ok, pid} = ExDataHoover.Nozzle.start_link(:unwrappable, UnwrappableBag)
      Process.flag(:trap_exit, true)

      catch_exit do
        ExDataHoover.Nozzle.sync_absorb(:unwrappable,
          trackee: %{"id" => 1},
          event: "foo event",
          props: %{"test" => "test"}
        )
      end

      assert_received({:EXIT, ^pid, _})
    end

    @tag :capture_log
    test "it raises an error if tag function is not defined in the provider" do
      {:ok, pid} = ExDataHoover.Nozzle.start_link(:untaggable, BagWithoutTrackeeId)
      Process.flag(:trap_exit, true)

      catch_exit do
        ExDataHoover.Nozzle.sync_absorb(:untaggable,
          trackee: %{"id" => 1},
          event: "foo event",
          props: %{"test" => "test"}
        )
      end

      assert_received({:EXIT, ^pid, _})
    end
  end
end

defmodule GoodProvider do
  def trackee_id(_), do: {:ok, "1"}
  def wrap(_), do: {:ok, "Done"}
end

defmodule UnwrappableBag do
  def trackee_id(_), do: {:ok, "1"}
end

defmodule BagWithoutTrackeeId do
  def wrap(_), do: {:ok, "Done"}
end
