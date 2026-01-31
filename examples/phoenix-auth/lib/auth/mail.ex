defmodule Auth.Mail do
  @moduledoc """
  Email functions using VeilMail SDK for authentication flows.
  """

  def client do
    VeilMail.client(api_key: System.get_env("VEILMAIL_API_KEY"))
  end

  defp from_email, do: System.get_env("VEILMAIL_FROM_EMAIL", "noreply@veilmail.xyz")
  defp app_url, do: System.get_env("APP_URL", "http://localhost:4000")

  def send_verification_email(email, name, token) do
    url = "#{app_url()}/auth/verify-email?token=#{token}"

    client()
    |> VeilMail.Emails.send(%{
      from: from_email(),
      to: email,
      subject: "Verify your email address",
      html: "<p>Hi #{name},</p><p>Click <a href=\"#{url}\">here</a> to verify your email.</p>",
      tags: ["auth", "verification"],
      type: "transactional"
    })
  end

  def send_password_reset_email(email, token) do
    url = "#{app_url()}/auth/reset-password?token=#{token}"

    client()
    |> VeilMail.Emails.send(%{
      from: from_email(),
      to: email,
      subject: "Reset your password",
      html: "<p>Click <a href=\"#{url}\">here</a> to reset your password.</p>",
      tags: ["auth", "password-reset"],
      type: "transactional"
    })
  end

  def send_two_factor_code(email, code) do
    client()
    |> VeilMail.Emails.send(%{
      from: from_email(),
      to: email,
      subject: "#{code} is your verification code",
      html: "<p>Your code: <strong>#{code}</strong></p><p>Expires in 5 minutes.</p>",
      tags: ["auth", "2fa"],
      type: "transactional"
    })
  end

  def send_welcome_email(email, name) do
    client()
    |> VeilMail.Emails.send(%{
      from: from_email(),
      to: email,
      subject: "Welcome!",
      html: "<p>Welcome, #{name}! Your account is active.</p>",
      tags: ["auth", "welcome"],
      type: "transactional"
    })
  end

  def send_password_changed_email(email) do
    client()
    |> VeilMail.Emails.send(%{
      from: from_email(),
      to: email,
      subject: "Your password was changed",
      html: "<p>Your password was changed. If you didn't do this, reset it immediately.</p>",
      tags: ["auth", "security"],
      type: "transactional"
    })
  end

  def send_two_factor_toggled_email(email, enabled) do
    status = if enabled, do: "enabled", else: "disabled"

    client()
    |> VeilMail.Emails.send(%{
      from: from_email(),
      to: email,
      subject: "Two-factor authentication #{status}",
      html: "<p>2FA has been #{status} on your account.</p>",
      tags: ["auth", "2fa", "security"],
      type: "transactional"
    })
  end
end
