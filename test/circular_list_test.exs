defmodule CircularListTest do
  use ExUnit.Case, async: true

  test "iterating through the list" do
    cl = CircularList.new([1,2,3])
    assert {1, cl} = CircularList.next(cl)
    assert {2, cl} = CircularList.next(cl)
    assert {3, cl} = CircularList.next(cl)
    assert {1, cl} = CircularList.next(cl)
    assert {2, cl} = CircularList.next(cl)
    assert {3, cl} = CircularList.next(cl)
  end

  test "zero length list" do
    cl = CircularList.new([])
    assert {nil, cl} = CircularList.next(cl)
    assert {nil, cl} = CircularList.next(cl)
  end
end
