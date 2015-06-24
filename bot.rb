require 'bundler'
Bundler.require

require "cinch"
require "cinch/plugins/identify"

bot = Cinch::Bot.new do
  configure do |c|
    c.plugins.plugins = [Cinch::Plugins::Identify]
    c.plugins.options[Cinch::Plugins::Identify] = {
      :username => ENV['CINCH_USERNAME']
      :password => ENV['CINCH_PASSWORD']
      :type     => :nickserv,
    }
  end
end

bot.start
