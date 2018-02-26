require_relative 'json_utilities'
require 'mechanize'

module AgentHandler

  def self.setup(api_extend, host: nil, parser: JSONParser)
    agent = Mechanize.new
    agent.follow_meta_refresh = true
    agent.redirect_ok = true
    agent.pluggable_parser.default = parser if parser != nil
    api_extend.each {|api| agent.extend(api)}
    agent.host = host
    agent
  end

end


