# JSON-RPC Server Startup
# This initializer starts the JSON-RPC server on application boot

Rails.application.config.after_initialize do
  # Only start the JSON-RPC server in server context (not console, rake, etc.)
  if defined?(Rails::Server) || ENV['START_JSON_RPC_SERVER'] == 'true'
    Thread.new do
      begin
        require 'jimson'
        require 'active_data_flow-connector-json_rpc'
        require 'active_data_flow-connector-source-json_rpc'

        config = Rails.application.config.json_rpc_server
        host = config[:host] || '0.0.0.0'
        port = config[:port] || 8999

        # Create the handler
        handler = ActiveDataFlow::Connector::JsonRpc::ServerHandler.new

        # Create and start the server
        server = Jimson::Server.new(handler, host: host, port: port)

        Rails.logger.info "=" * 60
        Rails.logger.info "JSON-RPC Server starting on #{host}:#{port}"
        Rails.logger.info "=" * 60

        # Store reference for DataFlow access
        Rails.application.config.json_rpc_handler = handler
        Rails.application.config.json_rpc_server_instance = server

        server.start
      rescue => e
        Rails.logger.error "Failed to start JSON-RPC server: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      end
    end

    # Give server time to start
    sleep 1
  end
end
