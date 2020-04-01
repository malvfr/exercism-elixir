defmodule NucleotideCount do
  @nucleotides [?A, ?C, ?G, ?T]

  @doc """
  Counts individual nucleotides in a DNA strand.

  ## Examples

  iex> NucleotideCount.count('AATAA', ?A)
  4

  iex> NucleotideCount.count('AATAA', ?T)
  1
  """
  @spec count(charlist(), char()) :: non_neg_integer()
  def count(strand, nucleotide) do
    case strand do
      [] -> 0
      [0] -> 0
      _ -> Enum.filter(strand, fn n -> n == nucleotide end) |> Enum.count()
    end
  end

  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> NucleotideCount.histogram('AATAA')
  %{?A => 4, ?T => 1, ?C => 0, ?G => 0}
  """
  @spec histogram(charlist()) :: map()
  def histogram(strand) do
    hist_counter = %{?A => 0, ?T => 0, ?C => 0, ?G => 0}
    # counts how many keys are in the map
    # We can make it RNA compatible just by add ?U
    nucleotides_keys = Map.keys(hist_counter)

    case strand do
      [] ->
        hist_counter

      # Dynamically gets the keys, counts the nucleotides that are in the list
      # pipes it through a lambda so that we can pass it as second argument to
      # the zip function to create a list of tuples {nucleotide : count}.
      # Finally, transforms it into a map
      _ ->
        nucleotides_keys
        |> Enum.map(fn key -> Enum.count(strand, fn nuc -> nuc == key end) end)
        |> (fn count -> Enum.zip(nucleotides_keys, count) end).()
        |> Enum.into(%{})
    end
  end
end
