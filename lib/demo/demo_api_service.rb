require 'mechanize'

module DEMO
  module API
    module RANDOM

      attr_accessor :host

      def get_randomuser()
        get @host + '/api'
      end

      def random_service(req)
        case req[:method]
          when 'get'
            get @host + req[:path], req[:params], nil, req[:headers]
          when 'post'
            post @host + req[:path], req[:params], req[:headers]
          else
            raise 'HTTP method not existed in API service'
        end
      end

    end
  end
end