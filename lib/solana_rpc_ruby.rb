require_relative 'solana_rpc_ruby/api_client'
require_relative 'solana_rpc_ruby/api_error'
require_relative 'solana_rpc_ruby/methods_wrapper'
require_relative 'solana_rpc_ruby/response'
require_relative 'solana_rpc_ruby/websocket_client'
require_relative 'solana_rpc_ruby/websocket_methods_wrapper'

# Namespace for classes and modules that handle connection with solana JSON RPC API.
module SolanaRpcRuby 
  class << self
    # Default cluster address that will be used if not passed.
    # @return [String] cluster address.
    attr_accessor :cluster

    # Default websocket cluster address that will be used if not passed.
    # @return [String] websocket cluster address.
    attr_accessor :ws_cluster

    # Default json rpc version that will be used.
    # @return [String] json rpc version.
    attr_accessor :json_rpc_version

    # Bearer token to be used for rpc auth (optional)
    # @return [String] bearer token.
    attr_accessor :bearer_token

    # Config set from initializer.
    # @return [String] encoding.
    def config
      yield self
    end
  end
end
