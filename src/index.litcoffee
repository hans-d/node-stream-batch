stream-batch
============
Batch streaming items. A batch is created whenever:
- maxWait ms since last items has arrived  (100)
- maxTime ms since first item in current batch arrived (infinity)
- maxItems items are in the batch (infinity)

    through = require 'through2'


    module.exports = (opts={}) ->

        opts.maxWait ?= 100

        batchId = 0
        batches = { 0: [] }

Keep track of set timeouts

        timeoutWait = null
        timeoutFirst = null


Keep reference to the stream

        stream = null


Buffer incoming data. Reset the wait timeout.
Flush when batch has reached its limit.

        bufferIt = (data, enc, done) ->
            stream = @ unless stream

            batches[batchId].push data
            clearTimeout timeoutWait if timeoutWait

            if opts.maxItems && batch.length >= opts.maxItems
                flush()
            else
                setFlushTimeout()
            done()


Write the collected batch to the pipe, and start a new batch.

        flush = () ->
            return unless batch.length

            if timeoutFirst
                clearTimeout timeoutFirst
                timeoutFirst = null

            previous = batchId
            batches[batchId + 1] = []
            batchId++

            stream.push batches[previous]
            delete batches[previous]

            setFlushTimeout()


Set timeouts for flushing.

        setFlushTimeout = () =>
            return unless batches[batchId].length

Restrict the time data is held in a batch

            if not timeoutFirst and opts.maxTime
                timeoutFirst = setTimeout flush, opts.maxTime


Restrict the time waiting for new data

            timeoutWait = setTimeout flush, opts.maxWait


Return the stream. Force flush on close.

        return through.obj bufferIt, (done) ->
            flush()
            done()
