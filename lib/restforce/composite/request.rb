module Restforce
  module Composite
    class Request
      attr_accessor :response
      attr_reader :verb, :url, :attrs

      def initialize(verb, url, attrs)
        @verb ||= verb
        @url ||= url
        @attrs ||= attrs
      end

      def reference_id
        "#{url}::#{object_id}"
      end

      def body
        {
          method: verb.upcase,
          url: url,
          referenceId: reference_id,
          body: attrs
        }
      end
    end
  end
end
