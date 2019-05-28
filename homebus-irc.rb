#!/usr/bin/env ruby

require './options'
require './app'

irc_app_options = IRCHomeBusAppOptions.new

irc = IRCHomeBusApp.new irc_app_options.options
irc.run!
