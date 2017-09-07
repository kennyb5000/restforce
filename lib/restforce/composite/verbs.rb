require 'uri'
require 'restforce/concerns/verbs'

module Restforce
  module Composite
    module Verbs
      extend Restforce::Concerns::Verbs

      # Internal: Defines a method to add HTTP requests with the passed in
      # verb to the composite batch.
      #
      # verb - Symbol name of the verb (e.g. :get).
      #
      # Examples
      #
      #   define_verb :get
      #   # => get '/services/data/v24.0/sobjects'
      #
      # Returns nil.

      def define_verb(verb)
        define_method verb do |*args, &block|
          add verb, *args
        end
      end
    end
  end
end
