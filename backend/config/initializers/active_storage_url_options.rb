# Make Active Storage URLs (the redirect endpoint *and* the signed disk URL it
# redirects to) reflect the host:port the request actually came in on. Without
# this, DiskService#private_url is called with an explicit host but no port, so
# the disk URL drops the port and downloads fail when the app is exposed on a
# non-standard port.
ActiveSupport.on_load(:active_storage_base_controller) do
  before_action do
    ActiveStorage::Current.url_options = {
      host: request.host,
      port: request.optional_port,
      protocol: request.protocol
    }
  end
end
