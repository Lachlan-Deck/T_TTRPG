defmodule PhoenixFrontendWeb.HandleRoll do
  @base_url "http://localhost:8088/graphql/"
  require Logger

  def roll(roll_string) do
    query = "{roll(tokens: \"#{roll_string}\")}"
    Logger.info("[HandleRoll] Processing roll request string: #{inspect(roll_string)}")


    case Req.post(@base_url, json: %{query: query}) do
      {:ok, %{status: 200, body: %{"data" => data} = body}} ->
        if errors = body["errors"] do
          {:error, List.first(errors)["message"]}
        else
          {:ok, data["roll"]}
        end

      {:ok, %{status: status}} ->
        {:error, "Server returned status #{status}"}

      {:error, exception} ->
        {:error, Exception.message(exception)}
    end
  end
end
