defmodule VeilMail.Forms do
  @moduledoc """
  Signup form management.
  """

  alias VeilMail.Client

  @doc """
  Create a new signup form.
  """
  @spec create(Client.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def create(%Client{} = client, params) do
    Client.post(client, "/v1/forms", params)
  end

  @doc """
  List all signup forms.
  """
  @spec list(Client.t(), keyword()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def list(%Client{} = client, params \\ []) do
    Client.get(client, "/v1/forms", params)
  end

  @doc """
  Get a form by ID.
  """
  @spec get(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def get(%Client{} = client, id) do
    Client.get(client, "/v1/forms/#{id}")
  end

  @doc """
  Update a form.
  """
  @spec update(Client.t(), String.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def update(%Client{} = client, id, params) do
    Client.put(client, "/v1/forms/#{id}", params)
  end

  @doc """
  Delete a form.
  """
  @spec delete(Client.t(), String.t()) :: :ok | {:error, VeilMail.Error.t()}
  def delete(%Client{} = client, id) do
    Client.delete(client, "/v1/forms/#{id}")
  end
end
