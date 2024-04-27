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
           |> TfIdf.build_tf_idf(lowercase: true) == %{
             "a" => 0.3703126778946051,
             "another" => 0.24345833490911345,
             "is" => 0.43137124351221257,
             "test" => 0.43137124351221257,
             "third" => 0.24345833490911345,
             "this" => 0.43137124351221257,
             "document." => 0.43137124351221257
           }
  end
end
