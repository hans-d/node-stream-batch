batch = require '../src/index'
assert = require 'stream-assert'
through = require 'through2'

describe 'stream-batch', ->

    inStream = null

    beforeEach ->
        inStream = through.obj()

    it 'should produce a batch on exceeding items', (done) ->

        stream = inStream
            .pipe batch maxItems: 2
            .pipe assert.length 2
            .pipe assert.end done

        for i in [1..4]
            inStream.write i
        inStream.end()
