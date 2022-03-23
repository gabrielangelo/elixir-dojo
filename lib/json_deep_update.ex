defmodule JsonDeepUpdate do
  @moduledoc """
  Parses any json structure iterating recursively
  by all its nested maps.
  Firstly starts getting the first json's key-value. if
  the value has any nested maps we iterate recursively by
  others nested layers until finished. as long the nested parse  happens,
  we make track of all the paths traveled, with this, we have the
  exactly trail of nested paths to update the copy of structure in order to remove
  the items inside @removable_itens, furthermore, we don't change the input state, otherwise
  we create a new copy where the state is changed.
  Problem name: Json cleaning
  Platform: Coderbyte
  """

  @removeable_itens ["N/D", "-", ""]

  @spec deep_update(map) :: map()
  def deep_update(data) when is_map(data) do
    do_deep_iter(Map.to_list(data), [], data)
  end

  def deep_update(data) when is_binary(data), do: deep_update(Poison.decode!(data))

  defp do_deep_iter([{key, value} | tail], path, map_copy) when is_map(value) do
    map_copy = do_deep_iter(Map.to_list(value), [key | path], map_copy)
    do_deep_iter(tail, get_path(path), map_copy)
  end

  defp do_deep_iter([{key, value} | tail], path, map_copy) when is_list(value) do
    map_copy =
      update_in(map_copy, Enum.reverse([key | path]), fn list ->
        Enum.reject(list, fn item_list -> item_list in @removeable_itens end)
      end)

    do_deep_iter(tail, path, map_copy)
  end

  defp do_deep_iter([{key, value} | tail], path, map_copy)
       when value in @removeable_itens do
    {_, map_copy} = pop_in(map_copy, Enum.reverse([key | path]))
    do_deep_iter(tail, path, map_copy)
  end

  defp do_deep_iter([], _, map_copy), do: map_copy

  defp do_deep_iter([_ | tail], path, map_copy), do: do_deep_iter(tail, path, map_copy)

  defp get_path([]), do: []

  defp get_path([item]), do: [item]

  defp get_path([_ | path]), do: path
end
