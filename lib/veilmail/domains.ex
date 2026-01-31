defmodule VeilMail.Domains do
  @moduledoc """
  Domain management for email sending.
  """

  alias VeilMail.Client

  @doc """
  Register a new domain.
  """
  @spec create(Client.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def create(%Client{} = client, params) do
    with {:ok, response} <- Client.post(client, "/v1/domains", params) do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  List all domains.
  """
  @spec list(Client.t(), keyword()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def list(%Client{} = client, params \\ []) do
    Client.get(client, "/v1/domains", params)
  end

  @doc """
  Get a single domain by ID.
  """
  @spec get(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def get(%Client{} = client, id) do
    with {:ok, response} <- Client.get(client, "/v1/domains/#{id}") do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Update a domain.
  """
  @spec update(Client.t(), String.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def update(%Client{} = client, id, params) do
    Client.patch(client, "/v1/domains/#{id}", params)
  end

  @doc """
  Trigger DNS verification for a domain.
  """
  @spec verify(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def verify(%Client{} = client, id) do
    with {:ok, response} <- Client.post(client, "/v1/domains/#{id}/verify") do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Delete a domain.
  """
  @spec delete(Client.t(), String.t()) :: :ok | {:error, VeilMail.Error.t()}
  def delete(%Client{} = client, id) do
    Client.delete(client, "/v1/domains/#{id}")
  end

  defp unwrap_data(%{"data" => data}) when is_map(data), do: data
  defp unwrap_data(response), do: response
end
