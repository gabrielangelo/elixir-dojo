defmodule JsonDeepUpdateTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Problems.JsonDeepUpdate

  test "test JsonDeepUpdate worst case when input is a map" do
    map_param = %{
      "personal_data" => %{
        "first_name" => "John",
        "last_name" => "Doe",
        "car_model" => "N/D",
        "identity" => %{
          "number" => "N/D",
          "emission_date" => "N/D",
          "issuer_organizations" => ~w<ssp-ce - N/D>
        }
      },
      "number" => "N/D",
      "extra_id" => "123"
    }

    assert %{
             "personal_data" => %{
               "first_name" => "John",
               "last_name" => "Doe",
               "identity" => %{
                 "issuer_organizations" => ~w<ssp-ce>
               }
             },
             "extra_id" => "123"
           } == JsonDeepUpdate.deep_update(map_param)

    json = Poison.encode!(map_param)

    assert %{
             "personal_data" => %{
               "first_name" => "John",
               "last_name" => "Doe",
               "identity" => %{
                 "issuer_organizations" => ~w<ssp-ce>
               }
             },
             "extra_id" => "123"
           } == JsonDeepUpdate.deep_update(json)
  end
end
