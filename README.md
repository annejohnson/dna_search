# DNASearch

DNASearch is a tool for looking up DNA sequences by species in Elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

1. Add dna_search to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:dna_search, "~> 0.0.1"}]
end
```

## TODO

- Make NCBI module behavior more configurable
  - prop
  - timeout
  - retstart
  - paging
- Gracefully handle HTTPotion errors
