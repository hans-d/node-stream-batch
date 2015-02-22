var through;

through = require('through2');

module.exports = function(opts) {
  var batchId, batches, bufferIt, flush, setFlushTimeout, stream, timeoutFirst, timeoutWait;
  if (opts == null) {
    opts = {};
  }
  if (opts.maxWait == null) {
    opts.maxWait = 100;
  }
  batchId = 0;
  batches = {
    0: []
  };
  timeoutWait = null;
  timeoutFirst = null;
  stream = null;
  bufferIt = function(data, enc, done) {
    if (!stream) {
      stream = this;
    }
    batches[batchId].push(data);
    if (timeoutWait) {
      clearTimeout(timeoutWait);
    }
    if (opts.maxItems && batch.length >= opts.maxItems) {
      flush();
    } else {
      setFlushTimeout();
    }
    return done();
  };
  flush = function() {
    var previous;
    if (!batch.length) {
      return;
    }
    if (timeoutFirst) {
      clearTimeout(timeoutFirst);
      timeoutFirst = null;
    }
    previous = batchId;
    batches[batchId + 1] = [];
    batchId++;
    stream.push(batches[previous]);
    delete batches[previous];
    return setFlushTimeout();
  };
  setFlushTimeout = (function(_this) {
    return function() {
      if (!batches[batchId].length) {
        return;
      }
      if (!timeoutFirst && opts.maxTime) {
        timeoutFirst = setTimeout(flush, opts.maxTime);
      }
      return timeoutWait = setTimeout(flush, opts.maxWait);
    };
  })(this);
  return through.obj(bufferIt, function(done) {
    flush();
    return done();
  });
};

//# sourceMappingURL=index.js.map
