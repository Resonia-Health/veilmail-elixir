defmodule VeilMail.Webhook do
  @moduledoc """
  Webhook signature verification utilities.

  ## Example

      body = ~s({"type":"email.delivered","data":{}})
      signature = "abc123..."
      secret = "whsec_xxxxx"

      case VeilMail.Webhook.verify(body, signature, secret) do
        {:ok, payload} -> handle_event(payload)
        {:error, :invalid_signature} -> send_resp(conn, 401, "Invalid signature")
      end
  """

  @doc """
  Verify a webhook signature using constant-time HMAC-SHA256 comparison.

  Returns `{:ok, decoded_payload}` if valid, `{:error, :invalid_signature}` if not.
  """
  @spec verify(String.t(), String.t(), String.t()) ::
          {:ok, map()} | {:error, :invalid_signature | :invalid_json}
  def verify(body, signature, secret) do
    expected = generate_signature(body, secret)

    if secure_compare(expected, signature) do
      case Jason.decode(body) do
        {:ok, decoded} -> {:ok, decoded}
        {:error, _} -> {:error, :invalid_json}
      end
    else
      {:error, :invalid_signature}
    end
  end

  @doc """
  Verify a webhook signature, raising on failure.
  """
  @spec verify!(String.t(), String.t(), String.t()) :: map()
  def verify!(body, signature, secret) do
    case verify(body, signature, secret) do
      {:ok, payload} -> payload
      {:error, reason} -> raise "Webhook verification failed: #{reason}"
    end
  end

  @doc """
  Generate an HMAC-SHA256 signature for a payload.
  """
  @spec generate_signature(String.t(), String.t()) :: String.t()
  def generate_signature(body, secret) do
    :crypto.mac(:hmac, :sha256, secret, body)
    |> Base.encode16(case: :lower)
  end

  defp secure_compare(a, b) when byte_size(a) != byte_size(b), do: false

  defp secure_compare(a, b) do
    a_bytes = :binary.bin_to_list(a)
    b_bytes = :binary.bin_to_list(b)

    Enum.zip(a_bytes, b_bytes)
    |> Enum.reduce(0, fn {x, y}, acc -> Bitwise.bor(acc, Bitwise.bxor(x, y)) end)
    |> Kernel.==(0)
  end
end
