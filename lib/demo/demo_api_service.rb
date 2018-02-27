require 'mechanize'

module DEMO
  module API
    module RANDOM

      attr_accessor :host

      def get_randomuser
        get @host + '/api', {}
      end

      def get_tax_info(id)
        get @host + '/api/v1/rest/datastore/'+id
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