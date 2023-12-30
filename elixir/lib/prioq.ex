defmodule Aoc2023.PrioQ do
  def extract_min([h | t], d), do: extract_min(t, d, h)

  def extract_min([], _d, key) do
    key
  end

  def extract_min([h | t], d, key) do
    cond do
      d[h] < d[key] -> extract_min(t, d, h)
      true -> extract_min(t, d, key)
    end
  end
end
