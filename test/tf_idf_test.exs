defmodule TfIdfTest do
  use ExUnit.Case
  doctest TfIdf

  test "generates word rankings map" do
    assert """
           This is a test document.
           This is another test document.
           This is a third test document.
           """
           |> String.split("\n", trim: true)
           |> TfIdf.build_model() == %TfIdf.Model{
             count: 3,
             docs: [
               {"This is a test document.",
                %TfIdf.Doc{
                  last_modified: ~U[2024-04-29 19:38:42.878419Z],
                  tf: %{"" => 1, "a" => 1, "document" => 1, "is" => 1, "test" => 1, "this" => 1},
                  count: 6
                }},
               {"This is another test document.",
                %TfIdf.Doc{
                  last_modified: ~U[2024-04-29 19:38:42.879522Z],
                  tf: %{
                    "" => 1,
                    "another" => 1,
                    "document" => 1,
                    "is" => 1,
                    "test" => 1,
                    "this" => 1
                  },
                  count: 6
                }},
               {"This is a third test document.",
                %TfIdf.Doc{
                  last_modified: ~U[2024-04-29 19:38:42.879533Z],
                  tf: %{
                    "" => 1,
                    "a" => 1,
                    "document" => 1,
                    "is" => 1,
                    "test" => 1,
                    "third" => 1,
                    "this" => 1
                  },
                  count: 7
                }}
             ],
             idf: %{
               "" => 0.0,
               "a" => 0.28768207245178085,
               "another" => 0.6931471805599453,
               "document" => 0.0,
               "is" => 0.0,
               "test" => 0.0,
               "third" => 0.6931471805599453,
               "this" => 0.0
             }
           }
  end

  test "wikipedia example" do
    model =
      """
      This is a a sample
      This is another another example example example
      """
      |> String.split("\n", trim: true)
      |> TfIdf.build_model()

    assert TfIdf.calculate_relevance(model, "example") ==
             [{"This is another another example example example", 0.17377076061778474}]

    assert TfIdf.calculate_relevance(model, "sample") ==
             [{"This is a a sample", 0.08109302162163289}]

    assert TfIdf.calculate_relevance(model, "this") == []
  end
end
