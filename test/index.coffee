batch = require '../src/index'
assert = require 'stream-assert'
through = require 'through2'

describe 'stream-batch', ->

    inStream = null

    beforeEach ->
        inStream = through.obj()

    describe 'should not produce a batch', ->

        beforeEach ->
            inStream = through.obj()

        it 'when stream receives no data', (done) ->
            inStream
                .pipe batch maxWait: 5, maxItems: 10
                .pipe assert.length 0
                .pipe assert.end done

            inStream.end()

    describe 'should produce a batch', ->

        beforeEach ->
            inStream = through.obj()

        describe 'when', ->

            beforeEach ->
                inStream = through.obj()

            it 'stream ends', (done) ->
                inStream
                    .pipe batch maxWait: 5, maxItems: 10
                    .pipe assert.length 1
                    .pipe assert.end done

                inStream.write 'one'
                inStream.end()


            it 'exceeding maxWait', (done) ->
                inStream
                    .pipe batch maxWait: 5, maxItems: 10
                    .pipe assert.length 2
                    .pipe assert.end done

                inStream.write 'one'
                setTimeout () ->
                    inStream.write 'two'
                    inStream.end()
                , 10


            it 'exceeding maxTime', (done) ->
                inStream
                    .pipe batch maxTime: 5, maxWait: 100, maxItems: 10
                    .pipe assert.length 2
                    .pipe assert.end done

                inStream.write 'one'
                setTimeout () ->
                    inStream.write 'two'
                    inStream.end()
                , 10

            it 'exceeding maxItems', (done) ->
                inStream
                    .pipe batch maxItems: 1
                    .pipe assert.length 2
                    .pipe assert.end done

                inStream.write 'one'
                inStream.write 'two'
                inStream.end()

        it 'with given number of items', (done) ->
            inStream
                .pipe batch maxItems: 3
                .pipe assert.length 2
                .pipe assert.first (item) -> item.length is 3
                .pipe assert.end done

            for i in [1..4]
                inStream.write i
            inStream.end()
