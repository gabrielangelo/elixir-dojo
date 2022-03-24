defmodule Problems.DoublyLinkedList do
  @moduledoc false

  defstruct data: nil, next: nil, previous: nil

  def new(%__MODULE__{} = current_node, data) do
    %__MODULE__{previous: current_node, next: nil, data: data}
  end

  def push(%__MODULE__{next: next} = node, data) do
    if is_nil(next) do
      %{node | next: new(node, data)}
    else
      %{node | next: push(next, data)}
    end
  end

  def bulk_push(data) do
    [head | tail] = data

    Enum.reduce(tail, %__MODULE__{data: head}, fn item, acc -> Map.merge(acc, push(acc, item)) end)
  end

  def head(%__MODULE__{data: data}), do: data

  def tail(%__MODULE__{next: nil, data: data}), do: data

  def tail(%__MODULE__{next: next, data: data, previous: previous}) do
    if !is_nil(previous) do
      IO.puts(data)
    end

    tail(next)
  end

  def add_at_front(%__MODULE__{} = node, data) do
    %__MODULE__{next: node, data: data}
  end

  def add_after(%__MODULE__{data: lk_data} = prev_node, after_data, data) do
    if lk_data == after_data do
      %{prev_node | next: %__MODULE__{previous: prev_node, next: prev_node.next, data: data}}
    else
      %{prev_node | next: add_after(prev_node.next, after_data, data)}
    end
  end

  def all_elements(node), do: do_all_elements(node, [])
  def do_all_elements(%__MODULE__{next: nil} = node, acc), do: Enum.reverse([node.data | acc])

  def do_all_elements(%__MODULE__{next: next} = node, acc),
    do: do_all_elements(next, [node.data | acc])
end
