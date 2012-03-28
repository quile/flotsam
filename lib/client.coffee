dgram  = require 'dgram'
rl     = require 'readline'
config = require './config'

client = null
i      = null


config.configFile process.argv[2], ( config, oldConfig) ->

    if client
        client.close()

    if i
        i.close()

    client = dgram.createSocket( 'udp4' )
    i = rl.createInterface( process.stdin, process.stdout )

    i.on "line", (line) ->
        buf = new Buffer(line)
        client.send( buf, 0, buf.length, config.port || 9899, config.host || "127.0.0.1" )

        if line.length == 0
            i.close()
            process.stdin.destroy()