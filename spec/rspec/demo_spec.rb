require 'rspec'
require 'mechanize'
require_relative '../support/agent_holder'
require_relative '../../lib/demo/demo_api_service'

describe 'Random Service APIs' do

  api_extends = [DEMO::API::RANDOM]
  random_host = 'http://randomuser.me'
  data_host = 'http://data.ntpc.gov.tw'

  let(:radonm_agent) {AgentHandler.setup(api_extends, host: random_host)}
  let(:data_agent) {AgentHandler.setup(api_extends, host: data_host)}

  context 'API - /api' do
    it 'returns 200 OK and valid results and page' do
      resp = radonm_agent.get_randomuser
      expect(resp.code).to eq('200')
      expect(resp.json[:info][:results]).to eq(1)
    end
  end

  context 'API - /api/v1/rest/datastore' do
    it 'returns 200 OK and valid results' do
      id = '382000000A-002895-001'
      resp = data_agent.get_tax_info(id)
      expect(resp.code).to eq('200')
      expect(resp.json[:success]).to eq(true)
      expect(resp.json[:result][:resource_id]).to eq(id)
    end
  end

end