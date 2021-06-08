class WebhooksController < ApplicationController
  skip_forgery_protection only: :receive
  rescue_with Stripe::SignatureVerificationError, status: 400
  rescue_with DiscordSlashCommand::WebhookVerificationError, status: 401

  def receive
    case params[:source]
    when "stripe"
      UserUpgrade.receive_webhook(request)
      head 200
    when "discord"
      json = DiscordSlashCommand.receive_webhook(request)
      render json: json
    else
      head 400
    end
  end
end
