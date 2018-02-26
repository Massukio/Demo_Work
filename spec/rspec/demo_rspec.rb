require 'rspec'
require 'mechanize'
require_relative '../support/rspec_config'
require_relative '../support/json_utilities'
require_relative '../support/agent_holder'
require_relative '../support/junit_formatter.rb'
require_relative '../support/matchers.rb'
require_relative '../../lib/demo/demo_api_service'


describe 'Random Service APIs' do

  api_extends = [DEMO::API::RANDOM]
  host = 'https://randomuser.me'

  let(:agent) {AgentHandler.setup(api_extends, host: host)}

  context 'API - /api' do

    it 'returns 200 OK and valid results and page', :aggregate_failures do
      resp = agent.get_randomuser
      expect(resp.code).to eq('200')
      expect(resp.json[:info].results).to eq(1)
    end

  end

end