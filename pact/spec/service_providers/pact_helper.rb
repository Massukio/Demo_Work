require 'pact'

Pact.service_consumer "Demo" do
  has_pact_with "Random-Service" do
    mock_service :random_service do
      port 1234
    end
  end
end