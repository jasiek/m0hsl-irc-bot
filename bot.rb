require 'bundler'
Bundler.require

require "cinch"
require "cinch/plugins/identify"
require "cinch/plugins/pskreporter"

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.net"
    c.channels = [ "#lhs-radio" ]
    c.plugins.plugins = [Cinch::Plugins::Identify, Cinch::Plugins::PSKReporter]
    c.plugins.options[Cinch::Plugins::Identify] = {
      username: ENV['CINCH_USERNAME'],
      password: ENV['CINCH_PASSWORD'],
      type: :nickserv,
    }
    c.plugins.options[Cinch::Plugins::PSKReporter] = {
      watchers: { '#lhs-radio' => ['m0hsl'] }
    }
  end
end

bot.start
