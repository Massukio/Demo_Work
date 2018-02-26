require_relative 'pact_helper'
require_relative '../../lib/demo/demo_api_service.rb'

describe DEMO::API::RANDOM, :pact => true do

  let(:agent) do
    agent = Mechanize.new
    agent.follow_meta_refresh = true
    agent.redirect_ok = true
    agent.extend(DEMO::API::RANDOM)
    agent.host=random_service.mock_service_base_url
    agent
  end

  def random_service_contract(desc, req, resp)
    case req[:method]
      when 'get'
        random_service
            .upon_receiving(req[:path] + ' :: ' + desc).with(
            method: :get,
            path: req[:path],
            query: req[:params],
            headers: req[:headers]
        ).
            will_respond_with(
                status: resp[:status],
                headers: resp[:headers],
                body: resp[:body]
            )
      when 'post'
        random_service
            .upon_receiving(req[:path] + desc).with(
            method: :post,
            path: req[:path],
            body: req[:params],
            headers: req[:headers]
        ).
            will_respond_with(
                status: resp[:status],
                headers: resp[:headers],
                body: resp[:body]
            )
    end
  end

  describe 'Random Service' do
    describe 'API - /api' do

      it 'returns 200 with random result but correct schema', :aggregate_failures do
        desc = 'randomuser.me - schema check'
        req = {
            method: 'get',
            path: '/api',
            params: {},
            headers: {}
        }
        resp = {
            status: 200,
            body: {
                    results: Pact.each_like({
                                                gender: Pact.like("male"),
                                                name: {
                                                    title: Pact.like("mr"),
                                                    first: Pact.like("matthew"),
                                                    last: Pact.like("kim")
                                                },
                                                location: {
                                                    street: Pact.like("4354 chester road"),
                                                    city: Pact.like("newcastle upon tyne"),
                                                    state: Pact.like("leicestershire")
                                                },
                                                email: Pact.like("matthew.kim@example.com"),
                                                login: {
                                                    username: Pact.like("yellowladybug523"),
                                                    password: Pact.like("iceberg"),
                                                    salt: Pact.like("ZTNsf6Pp"),
                                                    md5: Pact.like("4aea17aef6b1ce9ee8ccb6bd4e84e970"),
                                                    sha1: Pact.like("593b89966fd7f954733e4683b3582e9d93588cef"),
                                                    sha256: Pact.like("acb6bc5eb9541ab5fdfd18303bb5f3a93210b31577c1d22fde96a159522b2307")
                                                },
                                                dob: Pact.like("1983-08-16 21:14:15"),
                                                registered: Pact.like("2012-12-15 04:15:33"),
                                                phone: Pact.like("016977 2867"),
                                                cell: Pact.like("0717-257-389"),
                                                id: {
                                                    name: Pact.like("NINO"),
                                                },
                                                picture: {
                                                    large: Pact.like("https://randomuser.me/api/portraits/men/89.jpg"),
                                                    medium: Pact.like("https://randomuser.me/api/portraits/med/men/89.jpg"),
                                                    thumbnail: Pact.like("https://randomuser.me/api/portraits/thumb/men/89.jpg")
                                                },
                                                nat: Pact.like("GB")
                                            }),
                    info: {
                        seed: Pact.like("97b6684ca0ef911c"),
                        results: Pact.like(1),
                        page: Pact.like(1),
                        version: Pact.like("1.1")
                    }
            },
            header: {'Content-Type' => 'application/json; charset=utf-8'}
        }

      random_service_contract(desc,req,resp)
      agent.random_service(req)

      end

    end
  end
end
