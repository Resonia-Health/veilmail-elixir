defmodule VeilMail.Analytics do
  @moduledoc """
  Geo and device analytics.
  """

  alias VeilMail.Client

  @doc """
  Get organization-level geo analytics.
  """
  @spec geo(Client.t(), keyword()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def geo(%Client{} = client, params \\ []) do
    Client.get(client, "/v1/analytics/geo", params)
  end

  @doc """
  Get organization-level device analytics.
  """
  @spec devices(Client.t(), keyword()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def devices(%Client{} = client, params \\ []) do
    Client.get(client, "/v1/analytics/devices", params)
  end

  @doc """
  Get campaign-level geo analytics.
  """
  @spec campaign_geo(Client.t(), String.t(), keyword()) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def campaign_geo(%Client{} = client, campaign_id, params \\ []) do
    Client.get(client, "/v1/campaigns/#{campaign_id}/analytics/geo", params)
  end

  @doc """
  Get campaign-level device analytics.
  """
  @spec campaign_devices(Client.t(), String.t(), keyword()) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def campaign_devices(%Client{} = client, campaign_id, params \\ []) do
    Client.get(client, "/v1/campaigns/#{campaign_id}/analytics/devices", params)
  end
end
