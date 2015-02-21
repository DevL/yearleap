defmodule Yearleap do
  import Plug.Conn
  import Guardsafe

  def start do
    "PORT"
    |> System.get_env
    |> String.to_integer
    |> start
  end

  def start(port) do
    IO.inspect port
    IO.inspect Plug.Adapters.Cowboy.http __MODULE__, [], [port: port]
    :timer.sleep(:infinity)
  end

  def init(options), do: options

  def call(connection, _) do
    handle(connection, connection.path_info)
  end

  defp handle(connection, []) do
    bad_request(connection, "No year to check provided.")
  end

  defp handle(connection, [year|_]) do
    case validate_year(year) do
      {:ok, year} -> respond(connection, year)
      {:error, reason} -> bad_request(connection, reason)
    end
  end

  defp validate_year(year) do
    try do
      {:ok, String.to_integer(year)}
    rescue
      _ in ArgumentError -> {:error, "'#{year}' is an invalid year."}
    end
  end

  defp respond(connection, year) do
    connection
    |> put_resp_content_type("text/plain")
    |> send_resp(200, leap_year_response_for(year))
  end

  defp bad_request(connection, reason) do
    connection
    |> put_resp_content_type("text/plain")
    |> send_resp(400, reason)
  end

  defp leap_year_response_for(year) do
    if leap_year? year do
      "#{year} is a leap year!"
    else
      "#{year} is not a leap year."
    end
  end

  defp leap_year?(year) when divisible_by?(year, 400), do: true
  defp leap_year?(year) when divisible_by?(year, 100), do: false
  defp leap_year?(year), do: divisible_by?(year, 4)
end
