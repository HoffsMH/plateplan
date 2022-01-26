defmodule PlateplanTest do
  use ExUnit.Case

  test "start" do
    assert Plateplan.start(450) == :world
  end

  test "estart" do
    assert Plateplan.start(225)[0] == :world
  end

  test "s" do
    assert Plateplan.start(35) == :world
  end
end
