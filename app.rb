require 'homebus'
require 'homebus_app'
require 'summer'
require 'mqtt'
require 'json'


class IRCBot < Summer::Connection
  def initialize(callback)
    @callback = callback

    super('irc.freenode.net')
  end

  def channel_message(sender, channel, message)
    @callback.call(sender, channel, message)
  end
end

class IRCHomeBusApp < HomeBusApp
  def initialize(options)
    @options = options

    super
  end

  def setup!
  end

  def work!
    @irc = IRCBot.new(lambda {|sender, channel, message| self.irc_message(sender, channel, message); })
  end

  def irc_message(sender, channel, message)
    puts "got a message #{message}"

    obj = {
      id: @uuid,
      timestamp: Time.now.to_i,
      message: {
        server: 'irc.freenode.net',
        channel: channel,
        nick: sender[:nick],
        hostname: sender[:hostname],
        message: message
      }
    }

    # messages look like "FIRSTNAME INITIAL. has opened unit3 back door"
    # parse them into "(PERSON) has (VERBED) (DOOR)"
    # may also look like "unit3 access control is online"
    @mqtt.publish "/irc",
                  JSON.generate(obj),
                  true
  end

  def manufacturer
    'HomeBus'
  end

  def model
    'IRC bridge'
  end

  def friendly_name
    'IRC channel bridge'
  end

  def friendly_location
    "#{@options[:irc_channel]} on #{@options[:irc_server]}"
  end

  def serial_number
    ''
  end

  def pin
    ''
  end

  def devices
    [
      { friendly_name: model,
        friendly_location: friendly_location,
        update_frequency: 0,
        index: 0,
        accuracy: 0,
        precision: 0,
        wo_topics: [ '/irc' ],
        ro_topics: [],
        rw_topics: []
      }
    ]
  end
end
