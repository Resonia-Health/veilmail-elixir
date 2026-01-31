defmodule VeilMail.Audiences do
  @moduledoc """
  Audience and subscriber management.
  """

  alias VeilMail.Client

  @doc """
  Create a new audience.
  """
  @spec create(Client.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def create(%Client{} = client, params) do
    with {:ok, response} <- Client.post(client, "/v1/audiences", params) do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  List all audiences.
  """
  @spec list(Client.t(), keyword()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def list(%Client{} = client, params \\ []) do
    Client.get(client, "/v1/audiences", params)
  end

  @doc """
  Get an audience by ID.
  """
  @spec get(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def get(%Client{} = client, id) do
    with {:ok, response} <- Client.get(client, "/v1/audiences/#{id}") do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Update an audience.
  """
  @spec update(Client.t(), String.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def update(%Client{} = client, id, params) do
    with {:ok, response} <- Client.put(client, "/v1/audiences/#{id}", params) do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Delete an audience.
  """
  @spec delete(Client.t(), String.t()) :: :ok | {:error, VeilMail.Error.t()}
  def delete(%Client{} = client, id) do
    Client.delete(client, "/v1/audiences/#{id}")
  end

  # --- Subscribers ---

  @doc """
  Add a subscriber to an audience.
  """
  @spec add_subscriber(Client.t(), String.t(), map()) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def add_subscriber(%Client{} = client, audience_id, params) do
    with {:ok, response} <-
           Client.post(client, "/v1/audiences/#{audience_id}/subscribers", params) do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  List subscribers in an audience.
  """
  @spec list_subscribers(Client.t(), String.t(), keyword()) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def list_subscribers(%Client{} = client, audience_id, params \\ []) do
    Client.get(client, "/v1/audiences/#{audience_id}/subscribers", params)
  end

  @doc """
  Get a subscriber by ID.
  """
  @spec get_subscriber(Client.t(), String.t(), String.t()) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def get_subscriber(%Client{} = client, audience_id, subscriber_id) do
    with {:ok, response} <-
           Client.get(
             client,
             "/v1/audiences/#{audience_id}/subscribers/#{subscriber_id}"
           ) do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Update a subscriber.
  """
  @spec update_subscriber(Client.t(), String.t(), String.t(), map()) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def update_subscriber(%Client{} = client, audience_id, subscriber_id, params) do
    with {:ok, response} <-
           Client.put(
             client,
             "/v1/audiences/#{audience_id}/subscribers/#{subscriber_id}",
             params
           ) do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Remove a subscriber from an audience.
  """
  @spec remove_subscriber(Client.t(), String.t(), String.t()) ::
          :ok | {:error, VeilMail.Error.t()}
  def remove_subscriber(%Client{} = client, audience_id, subscriber_id) do
    Client.delete(client, "/v1/audiences/#{audience_id}/subscribers/#{subscriber_id}")
  end

  @doc """
  Confirm a subscriber.
  """
  @spec confirm_subscriber(Client.t(), String.t(), String.t()) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def confirm_subscriber(%Client{} = client, audience_id, subscriber_id) do
    with {:ok, response} <-
           Client.post(
             client,
             "/v1/audiences/#{audience_id}/subscribers/#{subscriber_id}/confirm"
           ) do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Import subscribers from a list.
  """
  @spec import_subscribers(Client.t(), String.t(), map()) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def import_subscribers(%Client{} = client, audience_id, params) do
    Client.post(client, "/v1/audiences/#{audience_id}/subscribers/import", params)
  end

  @doc """
  Export subscribers as CSV.
  """
  @spec export_subscribers(Client.t(), String.t(), keyword()) ::
          {:ok, String.t()} | {:error, VeilMail.Error.t()}
  def export_subscribers(%Client{} = client, audience_id, params \\ []) do
    Client.get_raw(client, "/v1/audiences/#{audience_id}/subscribers/export", params)
  end

  @doc """
  Get subscriber activity timeline.
  """
  @spec subscriber_activity(Client.t(), String.t(), String.t(), keyword()) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def subscriber_activity(%Client{} = client, audience_id, subscriber_id, params \\ []) do
    Client.get(
      client,
      "/v1/audiences/#{audience_id}/subscribers/#{subscriber_id}/activity",
      params
    )
  end

  @doc """
  Recalculate engagement scores for all subscribers.
  """
  @spec recalculate_engagement(Client.t(), String.t()) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def recalculate_engagement(%Client{} = client, audience_id) do
    Client.post(client, "/v1/audiences/#{audience_id}/recalculate-engagement", %{})
  end

  @doc """
  Get engagement statistics for an audience.
  """
  @spec get_engagement_stats(Client.t(), String.t()) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def get_engagement_stats(%Client{} = client, audience_id) do
    Client.get(client, "/v1/audiences/#{audience_id}/engagement-stats")
  end

  defp unwrap_data(%{"data" => data}) when is_map(data), do: data
  defp unwrap_data(response), do: response
end
