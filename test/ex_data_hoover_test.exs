defmodule ExDataHooverTest do
  use ExUnit.Case
  doctest ExDataHoover

  describe "anonymize/1" do
    test "returns nil data is nil" do
      assert ExDataHoover.anonymize(nil) == nil
    end

    test "returns the SHA256 of the string representation" do
      assert ExDataHoover.anonymize("foo") ==
               "2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae"
    end

    test "returns the SHA256 of the integer representation" do
      assert ExDataHoover.anonymize(42) ==
               "73475cb40a568e8da8a045ced110137e159f890ac4da883b6b17dc651b3a8049"
    end
  end
end
