defmodule VeilMail.Webhooks do
  @moduledoc """
  Webhook endpoint management.

  For signature verification, see `VeilMail.Webhook`.
  """

  alias VeilMail.Client

  @doc """
  Create a new webhook endpoint.
  """
  @spec create(Client.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def create(%Client{} = client, params) do
    with {:ok, response} <- Client.post(client, "/v1/webhooks", params) do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  List all webhook endpoints.
  """
  @spec list(Client.t(), keyword()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def list(%Client{} = client, params \\ []) do
    Client.get(client, "/v1/webhooks", params)
  end

  @doc """
  Get a webhook endpoint by ID.
  """
  @spec get(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def get(%Client{} = client, id) do
    with {:ok, response} <- Client.get(client, "/v1/webhooks/#{id}") do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Update a webhook endpoint.
  """
  @spec update(Client.t(), String.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def update(%Client{} = client, id, params) do
    with {:ok, response} <- Client.patch(client, "/v1/webhooks/#{id}", params) do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Delete a webhook endpoint.
  """
  @spec delete(Client.t(), String.t()) :: :ok | {:error, VeilMail.Error.t()}
  def delete(%Client{} = client, id) do
    Client.delete(client, "/v1/webhooks/#{id}")
  end

  @doc """
  Send a test event to a webhook endpoint.
  """
  @spec test(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def test(%Client{} = client, id) do
    Client.post(client, "/v1/webhooks/#{id}/test")
  end

  @doc """
  Rotate the signing secret for a webhook endpoint.
  """
  @spec rotate_secret(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def rotate_secret(%Client{} = client, id) do
    with {:ok, response} <-
           Client.post(client, "/v1/webhooks/#{id}/rotate-secret") do
      {:ok, unwrap_data(response)}
    end
  end

  defp unwrap_data(%{"data" => data}) when is_map(data), do: data
  defp unwrap_data(response), do: response
end
