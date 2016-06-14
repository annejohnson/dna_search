defmodule DNASearch.FlokiUtils do
  @moduledoc false

  def get_integer(floki_node) do
    floki_node
    |> Floki.FlatText.get
    |> Integer.parse
    |> elem(0)
  end
end
