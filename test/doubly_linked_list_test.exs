defmodule DoublyLinkedListTest do
  use ExUnit.Case, async: true

  alias Problems.DoublyLinkedList, as: DoublyLinkedList

  setup do
    data = Enum.to_list(1..10)
    doubly_linked_list = DoublyLinkedList.bulk_push(data)

    %{
      doubly_linked_list: doubly_linked_list,
      data: data
    }
  end

  test "test all_elements/1", %{doubly_linked_list: doubly_linked_list, data: data} do
    assert DoublyLinkedList.all_elements(doubly_linked_list) == data
  end

  test "test push/2", %{doubly_linked_list: doubly_linked_list, data: data} do
    assert doubly_linked_list
           |> DoublyLinkedList.push(56)
           |> DoublyLinkedList.all_elements() ==
             data ++ [56]
  end

  test "test add_after/3", %{doubly_linked_list: doubly_linked_list} do
    linked_list = DoublyLinkedList.add_after(doubly_linked_list, 5, 541)
    expected_result = Enum.to_list(1..5) ++ [541] ++ Enum.to_list(6..10)
    assert DoublyLinkedList.all_elements(linked_list) == expected_result
  end
end
