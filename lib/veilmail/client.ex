defmodule VeilMail.Client do
  @moduledoc """
  HTTP client for the Veil Mail API.
  """

  @default_base_url "https://api.veilmail.xyz"
  @default_timeout 30_000
  @version "0.1.0"

  @type t :: %__MODULE__{
          api_key: String.t(),
          base_url: String.t(),
          timeout: non_neg_integer()
        }

  @enforce_keys [:api_key]
  defstruct [:api_key, :base_url, :timeout]

  @doc false
  def new(api_key, opts \\ []) do
    unless String.starts_with?(api_key, "veil_live_") or
             String.starts_with?(api_key, "veil_test_") do
      raise ArgumentError, "API key must start with 'veil_live_' or 'veil_test_'"
    end

    %__MODULE__{
      api_key: api_key,
      base_url: String.trim_trailing(opts[:base_url] || @default_base_url, "/"),
      timeout: opts[:timeout] || @default_timeout
    }
  end

  @doc false
  def get(%__MODULE__{} = client, path, query \\ []) do
    url = client.base_url <> path

    filtered =
      query
      |> Enum.reject(fn {_k, v} -> is_nil(v) or v == "" end)

    opts =
      [
        headers: headers(client),
        receive_timeout: client.timeout
      ]
      |> maybe_add_params(filtered)

    case Req.get(url, opts) do
      {:ok, response} -> handle_response(response)
      {:error, exception} -> {:error, VeilMail.Error.from_exception(exception)}
    end
  end

  @doc false
  def get_raw(%__MODULE__{} = client, path, query \\ []) do
    url = client.base_url <> path

    filtered =
      query
      |> Enum.reject(fn {_k, v} -> is_nil(v) or v == "" end)

    opts =
      [
        headers: headers(client),
        receive_timeout: client.timeout,
        decode_body: false
      ]
      |> maybe_add_params(filtered)

    case Req.get(url, opts) do
      {:ok, %Req.Response{status: status, body: body}} when status in 200..299 ->
        {:ok, body}

      {:ok, %Req.Response{status: status, body: body}} ->
        parsed = try_parse_json(body)
        {:error, VeilMail.Error.from_response(status, parsed)}

      {:error, exception} ->
        {:error, VeilMail.Error.from_exception(exception)}
    end
  end

  @doc false
  def post(%__MODULE__{} = client, path, body \\ nil) do
    url = client.base_url <> path

    opts = [
      headers: headers(client),
      receive_timeout: client.timeout
    ]

    opts = if body, do: Keyword.put(opts, :json, body), else: opts

    case Req.post(url, opts) do
      {:ok, response} -> handle_response(response)
      {:error, exception} -> {:error, VeilMail.Error.from_exception(exception)}
    end
  end

  @doc false
  def patch(%__MODULE__{} = client, path, body) do
    url = client.base_url <> path

    case Req.patch(url,
           json: body,
           headers: headers(client),
           receive_timeout: client.timeout
         ) do
      {:ok, response} -> handle_response(response)
      {:error, exception} -> {:error, VeilMail.Error.from_exception(exception)}
    end
  end

  @doc false
  def put(%__MODULE__{} = client, path, body) do
    url = client.base_url <> path

    case Req.put(url,
           json: body,
           headers: headers(client),
           receive_timeout: client.timeout
         ) do
      {:ok, response} -> handle_response(response)
      {:error, exception} -> {:error, VeilMail.Error.from_exception(exception)}
    end
  end

  @doc false
  def delete(%__MODULE__{} = client, path) do
    url = client.base_url <> path

    case Req.delete(url,
           headers: headers(client),
           receive_timeout: client.timeout
         ) do
      {:ok, %Req.Response{status: status}} when status in 200..299 ->
        :ok

      {:ok, response} ->
        {:error, handle_error_response(response)}

      {:error, exception} ->
        {:error, VeilMail.Error.from_exception(exception)}
    end
  end

  defp headers(client) do
    [
      {"authorization", "Bearer #{client.api_key}"},
      {"user-agent", "veilmail-elixir/#{@version}"}
    ]
  end

  defp handle_response(%Req.Response{status: 204}) do
    {:ok, %{}}
  end

  defp handle_response(%Req.Response{status: status, body: body}) when status in 200..299 do
    {:ok, body}
  end

  defp handle_response(%Req.Response{} = response) do
    {:error, handle_error_response(response)}
  end

  defp handle_error_response(%Req.Response{status: status, body: body}) when is_map(body) do
    VeilMail.Error.from_response(status, body)
  end

  defp handle_error_response(%Req.Response{status: status, body: body}) when is_binary(body) do
    parsed = try_parse_json(body)
    VeilMail.Error.from_response(status, parsed)
  end

  defp handle_error_response(%Req.Response{status: status}) do
    VeilMail.Error.from_response(status, %{})
  end

  defp maybe_add_params(opts, []), do: opts
  defp maybe_add_params(opts, params), do: Keyword.put(opts, :params, params)

  defp try_parse_json(body) when is_binary(body) do
    case Jason.decode(body) do
      {:ok, parsed} -> parsed
      {:error, _} -> %{"message" => body}
    end
  end

  defp try_parse_json(body), do: body
end
