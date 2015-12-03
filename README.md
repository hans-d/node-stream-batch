stream-batch
===========

Batch streaming items. A batch is created whenever:
- maxWait ms since last items has arrived (default: 100)
- maxTime ms since first item in current batch arrived (default: infinity)
- maxItems items are in the batch (default: infinity)

A batch is an array of the collected events, and can be of different sizes.
Within the array, the sequence is the same order as they came in.


Usage example code:
```
var batch = require('stream-batch');

var someStream = ... // whatever stream
    .pipe( batch() )
    .pipe .... // whatever you want to do next

```
Example configuration
  - 200 ms after the last item is received:
    `batch({ maxWait: 200})`
  - 200 ms after the last item is received, but no longer as 500 ms
    after the first item was received:
    `batch({ maxWait: 200, maxTime: 500})`
  - 200 ms after the last item is received, but no longer as 500 ms
    after the first item was received or there are 100 items:
    `batch({ maxWait: 200, maxTime: 500, maxItems: 100})`



It could be used eg:
- streams where new items are received in bursts of unknown size,
  where you want to react to the burst and not to the
  individual items (but still need them for you actions)
- streams where new items are received that you want to work on in
  batches, but the speed of the receipt is unpredictable, eg due
  to network conditions, load of external servers etc
- batching output to a server, so that data is written at least
  every second and or earlier when the batch is of a certain size
