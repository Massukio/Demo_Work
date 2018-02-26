require 'pact/consumer/rspec'
require 'pact/tasks'
require 'pact/provider/proxy/tasks'
require 'rspec/core/rake_task'

Pact::ProxyVerificationTask.new :random_service do | task |
  pact_url = './spec/pacts/demo-random_service.json'
  task.pact_url pact_url, :pact_helper => './spec/service_providers/pact_helper.rb'
  task.provider_base_url 'https://randomuser.me'
  task.provider_app_version '1.0.0'
end

namespace :RSPEC do
  rspec_options = '-f JunitFormatter -o rspec_junit_results.xml -f d --color --tag ~wip'

  RSpec::Core::RakeTask.new(:run_ALL) do |t|
    rbfiles = File.join('spec/rspec/**', '*rspec.rb')
    t.pattern = Dir.glob(rbfiles)
    t.rspec_opts = [rspec_options]
  end

  RSpec::Core::RakeTask.new(:dryRun) do |t|
    rbfiles = File.join('spec/rspec/**', '*rspec.rb')
    t.pattern = Dir.glob(rbfiles)
    t.rspec_opts = ['--dry-run -f d --color --tag ~wip']
  end
end
