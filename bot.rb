require 'bundler'
Bundler.require

require "cinch"
require "cinch/plugins/identify"
require "cinch/plugins/pskreporter"

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = 'm0hsl-bot'
    c.server = "irc.freenode.net"
    c.channels = [ "#lhs-radio", "#london-hack-space", "#london-hack-space-infrastructure", "#london-hack-space-dev" ]
    c.plugins.plugins = [Cinch::Plugins::Identify,
                         Cinch::Plugins::PSKReporter,
                         Cinch::Plugins::TwitterWatch]
    c.plugins.options[Cinch::Plugins::Identify] = {
      username: ENV['CINCH_USERNAME'],
      password: ENV['CINCH_PASSWORD'],
      type: :nickserv,
    }
    c.plugins.options[Cinch::Plugins::PSKReporter] = {
      watchers: { '#lhs-radio' => ['m0hsl'] },
      color: :brown
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

bot.config.channels.each do |channel|
  bot.loggers << Cinch::Logger::CanonicalLogger.new(channel.gsub(/#/, ''), bot)
end

# We tweet only from time to time.
Cinch::Plugins::TwitterWatch.timers.last.interval = 600

bot.start
