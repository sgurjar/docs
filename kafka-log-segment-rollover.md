# Kafka log segment rollover
Provide `log.roll.jitter.ms` so that all segments wont rollover at same time.

~~~~
kafka-0.11.0.1\core\src\main\scala\kafka\log\Log.scala :
  private def maybeRoll(messagesSize: Int, maxTimestampInMessages: Long, maxOffsetInMessages: Long): LogSegment = {
    val segment = activeSegment
    val now = time.milliseconds                                                  // less than a random jitter
    val reachedRollMs = segment.timeWaitedForRoll(now, maxTimestampInMessages) > config.segmentMs - segment.rollJitterMs
    if (segment.size > config.segmentSize - messagesSize ||
        (segment.size > 0 && reachedRollMs) ||
        segment.index.isFull || segment.timeIndex.isFull || !segment.canConvertToRelativeOffset(maxOffsetInMessages)) {
      debug(s"Rolling new log segment in $name (log_size = ${segment.size}/${config.segmentSize}}, " +
          s"index_size = ${segment.index.entries}/${segment.index.maxEntries}, " +
          s"time_index_size = ${segment.timeIndex.entries}/${segment.timeIndex.maxEntries}, " +
          s"inactive_time_ms = ${segment.timeWaitedForRoll(now, maxTimestampInMessages)}/${config.segmentMs - segment.rollJitterMs}).")
      /*
        maxOffsetInMessages - Integer.MAX_VALUE is a heuristic value for the first offset in the set of messages.
        Since the offset in messages will not differ by more than Integer.MAX_VALUE, this is guaranteed <= the real
        first offset in the set. Determining the true first offset in the set requires decompression, which the follower
        is trying to avoid during log append. Prior behavior assigned new baseOffset = logEndOffset from old segment.
        This was problematic in the case that two consecutive messages differed in offset by
        Integer.MAX_VALUE.toLong + 2 or more.  In this case, the prior behavior would roll a new log segment whose
        base offset was too low to contain the next message.  This edge case is possible when a replica is recovering a
        highly compacted topic from scratch.
       */
      roll(maxOffsetInMessages - Integer.MAX_VALUE)
    } else {
      segment
    }
  }
~~~~

* defaults:
~~~~
  log.roll.hours = 1
  log.roll.jitter.hours = 0
  log.roll.jitter.ms = null
  log.roll.ms = null
~~~~

* logic used
  * subtract `random.nextInt % log.roll.jitter.ms` from `log.roll.ms` to compute time to roll. 

~~~~
if not log.roll.ms :
  log.roll.ms = (get("log.roll.hours").or(1) * 60 * 60 * 1000) 

if log.roll.jitter.hours > 0:
  log.roll.jitter.ms = log.roll.jitter.hours * 60 * 60 * 1000

timeWaitedForRoll = log.roll.ms - (randome.nextInt() % max(log.roll.ms, log.roll.jitter.ms))
~~~~
