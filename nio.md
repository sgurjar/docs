
* __Buffers__ which are containers for data.

* __Charsets__ and their associated decoders and encoders, which translate
between bytes and Unicode characters.

* __Channels__ of various types, which represent connections to entities
capable of performing I/O operations.

* __Selectors and selection keys__ which together with selectable channels
define a multiplexed, non-blocking I/O facility.

----
## `java.nio`

  * buffers, which are containers for data

<pre>
Buffers            | Description
========================================================
Buffer             | Position, limit, and capacity;
                   | clear, flip, rewind, and mark/reset
ByteBuffer         | Get/put, compact, views; allocate, wrap
MappedByteBuffer   | A byte buffer mapped to a file
CharBuffer         | Get/put, compact; allocate, wrap
DoubleBuffer       | ' '
FloatBuffer        | ' '
IntBuffer          | ' '
LongBuffer         | ' '
ShortBuffer        | ' '
ByteOrder          | Typesafe enumeration for byte orders
========================================================

  java.nio.Buffer
    |- ByteBuffer
        |- MappedByteBuffer
    |- CharBuffer
    |- DoubleBuffer
    |- FloatBuffer
    |- IntBuffer
    |- LongBuffer
    |- ShortBuffer

  java.nio.ByteOrder

</pre>

----
## `java.nio.channels`

  * Selector holds one or more Channels,

  * `Selector.select` will return a selected-key set, each key in selected-key
  represents status of (operations that Channels said its intersted in) some
  the registered Channels

  * Channels represents *connections to entities* that are capable of performing
  I/O operations, such as files and sockets; defines selectors, for multiplexed,
  non-blocking I/O operations.

<pre>
AbstractInterruptibleChannel << Channel, InterruptibleChannel
  |- FileChannel        << ByteChannel, GatheringByteChannel, ScatteringByteChannel             - A channel for reading, writing, mapping, and manipulating a file.
  |- SelectableChannel  << Channel                                                              - A channel that can be multiplexed via a Selector.
      |- AbstractSelectableChannel
          |- DatagramChannel      << ByteChannel, GatheringByteChannel, ScatteringByteChannel   - A selectable channel for datagram-oriented sockets.
          |- Pipe.SinkChannel     << GatheringByteChannel, WritableByteChannel                  - A channel representing the writable end of a Pipe.
          |- Pipe.SourceChannel   << ReadableByteChannel, ScatteringByteChannel                 - A channel representing the readable end of a Pipe.
          |- ServerSocketChannel                                                                - A selectable channel for stream-oriented listening (server) sockets.
          |- SocketChannel        << ByteChannel, GatheringByteChannel, ScatteringByteChannel   - A selectable channel for stream-oriented connecting (client) sockets.


Channels              - Utility methods for channels and streams.
FileChannel.MapMode   - A typesafe enumeration for file-mapping modes.
FileLock              - A token representing a lock on a region of a file.
Pipe                  - A pair of channels that implements a unidirectional pipe.
SelectionKey          - A token representing the registration of a SelectableChannel with a Selector.
Selector              - A multiplexor of SelectableChannel objects.


Closeable
  |- Channel                                      - A nexus for I/O operations.
      |- InterruptibleChannel                     - A channel that can be asynchronously closed and interrupted.
      |- ReadableByteChannel                      - A channel that can read bytes.
          |- ByteChannel < WritableByteChannel    - A channel that can read and write bytes.
          |- ScatteringByteChannel                - A channel that can read bytes into a sequence of buffers.
      |- WritableByteChannel                      - A channel that can write bytes.
          |- ByteChannel < ReadableByteChannel    - A channel that can read and write bytes.
          |- GatheringByteChannel                 - A channel that can write bytes from a sequence of buffers.
</pre>

  * A selector is a multiplexor [1] of selectable channels, which in turn are a
  special type of channel that can be put into *non-blocking mode*. To perform
  multiplexed I/O operations, one or more selectable channels are first created,
  put into non-blocking mode, and registered with a selector. Registering a
  channel specifies the set of I/O operations that will be tested for readiness
  by the selector, and returns a selection key that represents the registration.

  [1] __multiplexer__ can be considered as a *multiple-input, single-output* switch,
  and a __demultiplexer__ as a *single-input, multiple-output* switch

      `Channels` *--> registers with -->* `Selector`

  * Once some channels have been registered with a selector, *a selection operation*
  can be performed in order to discover which channels, if any, have become ready
  to perform one or more of the operations in which interest was previously
  declared. If a channel is ready then the key returned when it was registered
  will be added to the selector's selected-key set. The key set, and the keys
  within it, can be examined in order to determine the operations for which each
  channel is ready. From each key one can retrieve the corresponding channel in
  order to perform whatever I/O operations are required.

  * That a selection key indicates that its channel is ready for some operation
  is a __hint__, but not a guarantee, that such an operation can be performed
  by a thread without causing the thread to block. It is imperative that code
  that performs multiplexed I/O be written so as to __ignore__ these hints
  when they prove to be incorrect.

  * a new selectable __channel__ is created by invoking the static `open` method
  of the corresponding class. If a channel needs an associated socket then a
  `socket` will be created as a side effect of this operation.

  * __Selector__  A selectable channel's registration with a selector is
  represented by a `SelectionKey` object. A selector maintains three sets of
  selection keys:
      * The __key set__ contains the keys representing the current channel
      registrations of this selector. This set is returned by the `keys` method.
      * The __selected-key set__ is the set of keys such that each key's channel
      was detected to be ready for at least one of the operations identified
      in the key's interest set during a prior selection operation. This set
      is returned by the `selectedKeys` method. The selected-key set is always
      a subset of the key set.
      * The __cancelled-key set__ is the set of keys that have been cancelled but
      whose channels have not yet been deregistered. This set is *not directly
      accessible*. The cancelled-key set is always a subset of the key set. All
      three sets are empty in a newly-created selector.
      * A key is added to a selector's key set as a side effect of registering
      a channel via the channel's register method.
      * A key is added to its selector's cancelled-key set when it is cancelled,
      whether by closing its channel or by invoking its cancel method.
      * Keys are added to the selected-key set by selection operations. A key
      may be removed directly from the selected-key set by invoking the set's
      remove method or by invoking the remove method of an iterator obtained
      from the set. Keys are never removed from the selected-key set in any
      other way; they are not, in particular, removed as a side effect of
      selection operations. Keys may not be added directly to the selected-key set.

  * __selection operation__ Selection is performed by the `select()`,
  `select(long)`, and `selectNow()` methods, and involves three steps:
      1. Each key in the __cancelled-key set__ is removed from each key set of
      which it is a member, and its channel is deregistered. This step leaves
      the cancelled-key set empty.
      2. The underlying operating system is queried for an update as to the
      readiness of each remaining channel to perform any of the operations
      identified by its key's interest set as of the moment that the selection
      operation began. For a channel that is ready for at least one such
      operation, one of the following two actions is performed:
          a. If the channel's key is not already in the selected-key set then
          it is added to that set and its ready-operation set is modified to
          identify exactly those operations for which the channel is now reported
          to be ready. Any readiness information previously recorded in the
          ready set is discarded.
          b. Otherwise the channel's key is already in the selected-key set,
          so its ready-operation set is modified to identify any new operations
          for which the channel is reported to be ready. Any readiness information
          previously recorded in the ready set is preserved; in other words,
          the ready set returned by the underlying system is bitwise-disjoined
          into the key's current ready set.
      If all of the keys in the key set at the start of this step have empty
      interest sets then neither the selected-key set nor any of the keys'
      ready-operation sets will be updated.
      3. If any keys were added to the cancelled-key set while step (2) was in
      progress then they are processed as in step (1).

  Whether or not a selection operation blocks to wait for one or more channels
  to become ready, and if so for how long, is the only essential difference
  between the three selection methods- `select()`, `select(long)`, and `selectNow()`

### Concurrency

__Selectors__ are __threadsafe__ their __key-sets__ are __not__.

A thread blocked in one of the `select()` or `select(long)` methods may be
interrupted by some other thread in one of three ways:

  1. By invoking the selector's `wakeup` method,
  2. By invoking the selector's `close` method, or
  3. By invoking the blocked thread's `interrupt` method, in which case its
  interrupt status will be set and the selector's wakeup method will be invoked.

The `close` method synchronizes on the selector and all three key sets in
the same order as in a selection operation.

A selector's key and selected-key sets are __not__, in general, safe for use
by multiple concurrent threads. If such a thread might modify one of these
sets directly then access should be controlled by synchronizing on the set
itself. The iterators returned by these sets' iterator methods are *fail-fast*:
If the set is modified after the iterator is created, in any way except by
invoking the iterator's own `remove` method, then a `ConcurrentModificationException`
will be thrown.

----
## `java.nio.charset`


