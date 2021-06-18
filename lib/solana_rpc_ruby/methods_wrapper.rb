require 'json'
require 'pry'
module SolanaRpcRuby
  class MethodsWrapper
    attr_accessor :api_client

    attr_accessor :cluster

    def initialize(api_client: ApiClient, cluster: SolanaRpcRuby.cluster)
      @api_client = api_client.new(cluster)
    end

    def get_account_info(account_pubkey)
      method = 'getAccountInfo'
      http_method = :post
      params = [account_pubkey]

      body = create_json_body(method, method_params: params)

      response = api_client.call_api(
        body: body,
        http_method: http_method,
      )

      Response.new(response: response)
    end

    private
    def create_json_body(method, method_params:)
      # To make a JSON-RPC request, send an HTTP POST request with a Content-Type: application/json header. 
      # The JSON request data should contain 4 fields:
      # 
      # jsonrpc: <string>, set to "2.0"
      # id: <number>, a unique client-generated identifying integer
      # method: <string>, a string containing the method to be invoked
      # params: <array>, a JSON array of ordered parameter values
      # 
      body = base_body
      body[:method] = method
      body[:params] = [method_params, base_params].flatten
      body.to_json
    end

    def base_body
      {
        "jsonrpc": "2.0",
        "id": 1
      }
    end

    def base_params
        {
          'encoding': 'base58'
        }
    end
  end
end