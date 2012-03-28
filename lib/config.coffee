# --
fs   = require 'fs'
util = require 'util'

class Configuration extends process.EventEmitter
    constructor: (file, onchange) ->
        @file = file
        self = this

        @on('configChanged', ->
            util.log util.format( "%j", self.config ) if config.debug
            onchange.apply( null, [self.config, self.oldConfig] )
        )

        fs.watchFile( file, (curr, prev) =>
            if curr.mtime > prev.mtime
                util.log "curr is #{curr.mtime} prev is #{prev.mtime}"
                @updateConfig()
        )

        @updateConfig()

    updateConfig: ->
        util.log "reading config file #{@file}"

        try
            foo = fs.readFileSync( @file )
        catch e
            throw e

        @oldConfig = @config
        @config = eval "config = #{foo}"
        @emit( 'configChanged', @config )


exports.configFile = ( file, configFunction ) ->
    cfg = new Configuration( file, configFunction )
