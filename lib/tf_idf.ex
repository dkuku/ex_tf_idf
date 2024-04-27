defmodule TfIdf do
  alias :math, as: Math

  def build_tf_idf(documents, opts) do
    word_hashmap = generate_word_hashmap(documents, opts[:lowercase])

    idf =
      documents
      |> generate_unique_word_hashmap(opts[:lowercase])
      |> calculate_idf(length(documents))

    word_hashmap
    |> calculate_tf()
    |> calculate_tf_idf(idf)
    |> l2_normalize()
  end

  def generate_word_hashmap(documents, _lowercase = true) do
    documents
    |> Enum.map(&String.downcase/1)
    |> Enum.flat_map(fn document -> String.split(document, ~r/\s+/) end)
    |> Enum.frequencies()
  end

  def generate_word_hashmap(documents, _) do
    documents
    |> Enum.flat_map(fn document -> String.split(document, ~r/\s+/) end)
    |> Enum.frequencies()
  end

  def generate_unique_word_hashmap(documents, _lowercase = true) do
    documents
    |> Enum.flat_map(fn document ->
      for word <- String.split(document, ~r/\s+/), uniq: true, do: String.downcase(word)
    end)
    |> Enum.frequencies()
  end

  def generate_unique_word_hashmap(documents, _) do
    documents
    |> Enum.flat_map(fn document ->
      for word <- String.split(document, ~r/\s+/), uniq: true, do: word
    end)
    |> Enum.frequencies()
  end

  def calculate_tf(freq_map) do
    total_words = freq_map |> Map.values() |> Enum.sum()
    Map.new(freq_map, fn {word, count} -> {word, count / total_words} end)
  end

  def calculate_idf(freq_map, docs_count) do
    Map.new(freq_map, fn {word, word_count} ->
      documents_with_term = (docs_count + 1) / (word_count + 1)

      {word, Math.log(documents_with_term) + 1}
    end)
  end

  def calculate_tf_idf(tf, idf) do
    Map.new(tf, fn {word, count} ->
      {word, count * Map.get(idf, word, 0)}
    end)
  end

  def l2_normalize(tf_idf) do
    l2_norm =
      tf_idf
      |> Map.values()
      |> Enum.map(&Math.pow(&1, 2))
      |> Enum.sum()
      |> Math.sqrt()

    Map.new(tf_idf, fn {word, value} -> {word, value / l2_norm} end)
  end
end
