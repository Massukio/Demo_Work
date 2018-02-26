RSpec.configure do |config|
  # Color console output
  config.tty = true

  # Providing access to spec context from within spec
  config.before(:each) do |spec|
    @spec = spec.metadata
  end

end