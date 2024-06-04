defmodule MonolitoTest do
  use ExUnit.Case
  doctest Monolito

  test "greets the world" do
    assert Monolito.hello() == :world
  end
end
