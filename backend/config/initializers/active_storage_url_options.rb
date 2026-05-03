# Make Active Storage URLs (redirect + disk download) reflect the host:port
# of the actual incoming request, not whatever RAILS_HOST defaults to. Without
# this, the redirect controller builds a disk URL that drops the port, so
# clients hitting the app on a non-default port cannot download attachments.
Rails.application.config.to_prepare do
  ActiveStorage::BaseController.before_action do
    ActiveStorage::Current.url_options = {
      host: request.host,
      port: request.optional_port,
      protocol: request.protocol
    }
  end
end
