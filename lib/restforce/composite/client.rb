module Restforce
  module Composite
    class Client
      include Restforce::Composite::Api
      include Restforce::Composite::Request
      attr_reader :requests, :base_client, :key

      def initialize(base_client, key)
        @base_client = base_client
        @requests = {}
        @key = key
      end

      def add(verb, *args)
        url = args[0]
        attrs = args[1]
        request = Restforce::Composite::Request.new(verb, url, attrs)
        @requests[request.reference_id] = request
      end

      def execute
        request_bodies = @requests.values.map(&:body)

        request_bodies.in_groups_of(25).each do |attrs|
          response = handle_errors base_client.connection.send('post',
                                                               'composite/',
                                                               key => attrs.compact)
        end

        response
      end

      def handle_errors(response)
        response.body['compositeResponse'].map do |result|
          ref_id = result['body']['referenceId']
          message = result['body'][0]['message']
          case result['httpStatusCode']
            when 404
              error = "Record Not Found: #{message}"
            when 401
              error = "Unauthorized: #{message}"
            when 413
              error = "HTTP 413 - Request Entity Too Large: #{message}"
            when 400...600
              error = "ClientError: #{message}"
          end
          @requests[ref_id].response = error.nil? ? result['body'] : error
        end
      end
    end
  end
end
