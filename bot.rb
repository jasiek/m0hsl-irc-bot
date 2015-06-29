require 'bundler'
Bundler.require

require "cinch"
require "cinch/plugins/identify"
require "cinch/plugins/pskreporter"

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.net"
    c.channels = [ "#lhs-radio" ]
    c.plugins.plugins = [Cinch::Plugins::Identify,
                         Cinch::Plugins::PSKReporter,
                         Cinch::Plugins::TwitterWatch]
    c.plugins.options[Cinch::Plugins::Identify] = {
      username: ENV['CINCH_USERNAME'],
      password: ENV['CINCH_PASSWORD'],
      type: :nickserv,
    }
    c.plugins.options[Cinch::Plugins::PSKReporter] = {
      watchers: { '#lhs-radio' => ['m0hsl'] }
    }
    c.plugins.options[Cinch::Plugins::TwitterWatch] = {
      consumer_key:    ENV['TWITTER_CONSUMER_KEY'],
      consumer_secret: ENV['TWITTER_CONSUMER_SECRET'],
      access_token:    ENV['TWITTER_ACCESS_TOKEN'],
      access_secret:   ENV['TWITTER_ACCESS_SECRET'],
      watchers: {
        '#lhs-radio' => ['m0hsl']
      }
    }
  end
end

bot.loggers << Cinch::Logger::CanonicalLogger.new('#lhs-radio', bot)

# We tweet only from time to time.
Cinch::Plugins::TwitterWatch.timers.last.interval = 600

bot.start
