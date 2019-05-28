require 'homebus_app_options'

class IRCHomeBusAppOptions < HomeBusAppOptions
  def app_options(op)
    irc_help = "IRC server domain name or IP address"
    channel_help = "IRC channel name (no #)"

    op.separator 'IRC options:'
    op.on('-i', '--irc IRC_SERVER', irc_help) { |value| options[:irc_server] = value }
    op.on('-c', '--channel channelname', channel_help) { |value| options[:irc_channel] = value }
    op.separator ''
  end

  def banner
    'HomeBus IRC bridge'
  end

  def version
    '0.0.1'
  end

  def name
    'homebus-irc'
  end
end
