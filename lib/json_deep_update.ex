defmodule JsonDeepUpdate do
  @moduledoc """
  Parses any json structure iterating recursively
  by all its nested maps.
  Firstly starts getting the first json's key-value. If
  the value has any nested maps we iterates recurvely by
  others nested layers until finish. as long the parse happens,
  we make track of al the path traveled, with this, we have the
  exactly track to update the copy of structure in order to remove
  the itens inside @removable_itens
  """

  @removeable_itens ["N/D", "-", ""]

  def deep_update(data) do
    do_deep_iter(Map.to_list(data), [], data)
  end

  defp do_deep_iter([{key, value} | tail], path, aux) when is_map(value) do
    aux = do_deep_iter(Map.to_list(value), [key | path], aux)
    do_deep_iter(tail, get_path(path), aux)
  end

  defp do_deep_iter([{key, value} | tail], path, aux) when is_list(value) do
    aux =
      update_in(aux, Enum.reverse([key | path]), fn list ->
        Enum.reject(list, fn item_list -> item_list in @removeable_itens end)
      end)

    do_deep_iter(tail, path, aux)
  end

  defp do_deep_iter([{key, value} | tail], path, aux)
       when value in @removeable_itens do
    {_, aux} = pop_in(aux, Enum.reverse([key | path]))
    do_deep_iter(tail, path, aux)
  end

  defp do_deep_iter([], _, aux), do: aux

  defp do_deep_iter([_ | tail], path, aux), do: do_deep_iter(tail, path, aux)

  defp get_path([]), do: []

  defp get_path([item]), do: [item]

  defp get_path([_ | path]), do: path
end
