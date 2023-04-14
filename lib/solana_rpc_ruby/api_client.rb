require 'net/http'
module SolanaRpcRuby
  ##
  # ApiClient class serves as a client for solana JSON RPC API.
  # @see https://docs.solana.com/developing/clients/jsonrpc-api
  class ApiClient
    OPEN_TIMEOUT = 300
    READ_TIMEOUT = 300

    # Determines which cluster will be used to send requests.
    # @return [String]
    attr_accessor :cluster

    # Use bearer token if present in config
    # @return [String]
    attr_accessor :bearer_token

    # Default headers.
    # @return [Hash]
    attr_accessor :default_headers

    # Initialize object with cluster address where requests will be sent.
    #
    # @param cluster [String]
    def initialize(cluster = nil, bearer_token = nil)
      @cluster = cluster || SolanaRpcRuby.cluster
      @bearer_token = bearer_token || SolanaRpcRuby.bearer_token

      message = 'Cluster is missing. Please provide default cluster in config or pass it to the client directly.'
      raise ArgumentError, message unless @cluster
    end

    # Sends request to the api.
    #
    # @param body [Hash]
    # @param http_method [Symbol]
    # @param params [Hash]
    #
    # @return [Object] Net::HTTPOK
    def call_api(body:, http_method:, params: {})
      uri = URI.parse(@cluster)

      request = Net::HTTP::Post.new(uri, default_headers)
      request.body = body

      Net::HTTP.start(
        uri.host,
        uri.port,
        use_ssl: true,
        open_timeout: OPEN_TIMEOUT,
        read_timeout: READ_TIMEOUT
      ) do |http|
        http.request(request)
      end
    rescue Timeout::Error,
           Net::HTTPError,
           Net::HTTPNotFound,
           Net::HTTPClientException,
           Net::HTTPFatalError,
           Net::ReadTimeout,
           Errno::ECONNREFUSED,
           SocketError => e

      raise ApiError.new(error_class: e.class, message: e.message)
    rescue StandardError => e
      message = "#{e.class} #{e.message}\n Backtrace: \n #{e.backtrace}"
      raise ApiError.new(error_class: e.class, message: e.message)
    end

    private

    def default_headers
      headers = { 'Content-Type' => 'application/json' }
      headers['Authorization'] = "Bearer #{@bearer_token}" if @bearer_token
      headers
    end
  end
end
