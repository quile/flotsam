#!/usr/bin/env coffee
#------------------------------------------------
# flotsam : collect up bits and pieces of
# runtime information that might be useful -
# statistics, exceptions / stack traces,
#
#------------------------------------------------

dgram  = require 'dgram'
util   = require 'util'
config = require './config'

# -- set up in-memory stuff

server = null
messageCount = 0

# -- wrap the whole server in a watcher that watches the
# -- config file for any changes and restarts the
# -- server hot, without losing any data.

config.configFile process.argv[2], (config, oldConfig) ->
    util.log( util.format( "Loading config %j", config) ) if config.debug

    if server
        server.close()

    # -- create the server and set up the event handlers
    server = dgram.createSocket( 'udp4' )

    server.on("listening", -> util.log "flotsam listening on port #{config.port}." )
    server.on("message", (message) ->
        util.log "#{messageCount} STFU! #{message}"
        messageCount += 1
    )
    server.on("close", -> util.log "CIAO" )
    server.on("error", -> util.log "DOH!" )

    # -- this one binds the server to the host/port and
    # -- makes it available for connections.
    server.bind( config.port || "9899", config.host || "127.0.0.1" )
