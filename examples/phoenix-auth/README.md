# Phoenix Auth Example with VeilMail

Authentication email integration using the VeilMail Elixir SDK in a Phoenix application.

## Key Files

- `lib/auth/mail.ex` - Mail module with auth email functions

## Setup

1. Add the VeilMail dependency to your `mix.exs`:
   ```elixir
   defp deps do
     [{:veilmail, "~> 0.1"}]
   end
   ```
2. Copy `lib/auth/mail.ex` into your Phoenix project
3. Set environment variables:
   ```bash
   export VEILMAIL_API_KEY=veil_live_your_key
   export VEILMAIL_FROM_EMAIL=noreply@yourdomain.com
   export APP_URL=https://yourdomain.com
   ```
4. Call `Auth.Mail` functions from your auth controllers or LiveViews

## Emails Covered

- Email verification
- Password reset
- Two-factor authentication codes
- Welcome email
- Password changed notification
- 2FA toggled notification
