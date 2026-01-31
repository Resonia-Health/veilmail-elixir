defmodule VeilMail.Templates do
  @moduledoc """
  Email template management.
  """

  alias VeilMail.Client

  @doc """
  Create a new template.
  """
  @spec create(Client.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def create(%Client{} = client, params) do
    with {:ok, response} <- Client.post(client, "/v1/templates", params) do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  List all templates.
  """
  @spec list(Client.t(), keyword()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def list(%Client{} = client, params \\ []) do
    Client.get(client, "/v1/templates", params)
  end

  @doc """
  Get a template by ID.
  """
  @spec get(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def get(%Client{} = client, id) do
    with {:ok, response} <- Client.get(client, "/v1/templates/#{id}") do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Update a template.
  """
  @spec update(Client.t(), String.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def update(%Client{} = client, id, params) do
    with {:ok, response} <- Client.patch(client, "/v1/templates/#{id}", params) do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Preview a template with sample data.
  """
  @spec preview(Client.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def preview(%Client{} = client, params) do
    Client.post(client, "/v1/templates/preview", params)
  end

  @doc """
  Delete a template.
  """
  @spec delete(Client.t(), String.t()) :: :ok | {:error, VeilMail.Error.t()}
  def delete(%Client{} = client, id) do
    Client.delete(client, "/v1/templates/#{id}")
  end

  defp unwrap_data(%{"data" => data}) when is_map(data), do: data
  defp unwrap_data(response), do: response
end
