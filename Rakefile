require 'pact/consumer/rspec'
require 'pact/tasks'
require 'pact/provider/proxy/tasks'

Pact::ProxyVerificationTask.new :random_service do | task |
  pact_url = './spec/pacts/demo-random_service.json'
  task.pact_url pact_url, :pact_helper => './spec/service_providers/pact_helper.rb'
  task.provider_base_url 'https://randomuser.me'
  task.provider_app_version '1.0.0'
end