defmodule TfIdf do
  alias :math, as: Math

  defmodule Doc do
    defstruct [:last_modified, tf: %{}, count: 0]
  end

  defmodule Model do
    defstruct docs: [], count: 0, idf: %{}
  end

  def build_model(docs) do
    docs
    |> generate_docs_tf()
    |> generate_idf()
  end

  def calculate_relevance(model, query) do
    model.docs
    |> Enum.reduce([], fn {doc_name, %{tf: tf, count: total_count}}, acc ->
      score =
        query
        |> String.downcase()
        |> String.split(~r/[^a-zA-Z]/)
        |> Enum.map(fn token ->
          idf = Map.get(model.idf, token, 0)
          token_count = Map.get(tf, token, 0)
          tf = token_count / total_count
          tf * idf
        end)
        |> Enum.sum()

      if score == 0 do
        acc
      else
        [{doc_name, score} | acc]
      end
    end)
    |> Enum.sort_by(fn {_, score} -> score end, :desc)
  end

  def calculate_token_value(model, token) do
    idf = Map.get(model.idf, token, 0)

    model.docs
    |> Enum.map(fn {doc_name, %{tf: tf, count: total_count}} ->
      token_count = Map.get(tf, token, 0)
      tf = token_count / total_count
      {doc_name, tf * idf}
    end)
  end

  def generate_docs_tf(docs) do
    Enum.map(docs, fn doc ->
      words =
        doc
        |> String.downcase()
        |> String.split(~r/[^a-zA-Z]/)

      n = length(words)

      tf =
        words
        |> Enum.frequencies()

      {doc, %TfIdf.Doc{tf: tf, last_modified: DateTime.utc_now(), count: n}}
    end)
  end

  def generate_idf(docs) do
    n = length(docs)

    idf =
      docs
      |> Enum.flat_map(&Map.keys(elem(&1, 1).tf))
      |> Enum.frequencies()
      |> Map.new(fn {t, c} -> {t, Math.log((n + 1) / (c + 1))} end)

    %TfIdf.Model{docs: docs, count: n, idf: idf}
  end
end
