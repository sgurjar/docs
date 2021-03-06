Item 69: Prefer concurrency utilities to wait and notify
================================================================================

    // Concurrent canonicalizing map atop ConcurrentMap - faster!
    public static String intern(String s) {
      String result = map.get(s);
      if (result == null) {
        result = map.putIfAbsent(s, s);
        if (result == null)
        result = s;
      }
      return result;
    }


`wait` and `notify`
--------------------------------------------------------------------------------
The `wait` method is used to make a thread wait for some condition. It must be
invoked inside a `synchronized` region that locks the object on which it is invoked.

    // The standard idiom for using the wait method
    synchronized (obj) {
      while (<condition does not hold>)
        obj.wait(); // (Releases lock, and reacquires on wakeup)

      ... // Perform action appropriate to condition
    }

__Always use the wait loop idiom to invoke the `wait` method; *never* invoke it
outside of a loop.__

The loop serves to test the condition *before* and *after* waiting.

Testing the condition *before* waiting and skipping the wait if the condition
already holds are necessary to ensure *liveness*. If the condition already holds and
the `notify` (or `notifyAll`) method has already been invoked before a thread
waits, there is no guarantee that the thread will *ever* wake from the `wait`.

Testing the condition after waiting and waiting again if the condition does not
hold are necessary to ensure safety. If the thread proceeds with the action when
the condition does not hold, it can destroy the invariant guarded by the lock.

###There are several reasons a thread might wake up when the condition does not hold:

* Another thread could have obtained the lock and changed the guarded state between
the time a thread invoked notify and the time the waiting thread woke.

* Another thread could have invoked notify accidentally or maliciously when
the condition did not hold. Classes expose themselves to this sort of mischief
by waiting on publicly accessible objects. Any wait contained in a synchronized
method of a publicly accessible object is susceptible to this problem.

* The notifying thread could be overly "generous" in waking waiting threads.
For example, the notifying thread might invoke notifyAll even if only some
of the waiting threads have their condition satisfied.

* The waiting thread could (rarely) wake up in the absence of a `notify`. This is
known as a __spurious__ wakeup [Posix, 11.4.3.6.1; JavaSE6].

###A related issue is whether you should use `notify` or `notifyAll` to wake
waiting threads.

Recall that `notify` wakes a single waiting thread, assuming such a thread exists,
and notifyAll wakes all waiting threads.

It is often said that you should always use `notifyAll`. This is reasonable,
conservative advice. It will always yield correct results because it guarantees
that you'll wake the threads that need to be awakened. You may wake some other
threads, too, but this won't affect the correctness of your program. These
threads will check the condition for which they're waiting and, finding it
false, will continue waiting.

As an optimization, you may choose to invoke `notify` instead of `notifyAll`
if all threads that could be in the wait-set are waiting for the same condition and
only one thread at a time can benefit from the condition becoming true.

Even if these conditions appear true, there may be cause to use `notifyAll` in
place of `notify`. Just as placing the `wait` invocation in a loop protects against
accidental or malicious notifications on a publicly accessible object, using `notifyAll`
in place of `notify` protects against accidental or malicious waits by an
unrelated thread. Such waits could otherwise "swallow" a critical notification,
leaving its intended recipient waiting indefinitely.

###from [[concurrency-interest] Propagation of signals to non-interrupted thread](http://cs.oswego.edu/pipermail/concurrency-interest/2011-November/008366.html)

[1](http://cs.oswego.edu/pipermail/concurrency-interest/2011-November/008371.html)
Spurious wakeups should always be considered possible even if the hardware and
JVM don't allow it.  LockSupport.unpark() can be called by any thread in any
piece of code. It has a globally accessible flag. One piece of code could call
`unpark()` and cause what seems to be a __spurious__ wakeup in another piece of code.

For example, let's say some buggy code allows for two threads (A & B) to call
`LockSupport.unpark()` on the same thread (C). Thread A calls unpark(). Thread C
wakes up exits that piece of code and then goes into another piece of code.
Thread C then calls `LockSupport.park()`. Thread B gets some CPU time and calls
`LockSupport.unpark()` on Thread C. Thread C now wakes up and thinks it has been
signaled correctly. This problem is really tough to debug because the two
pieces of code are completely unrelated except via LockSupport.

Coding for spurious wakeups (i.e. rechecking the condition) is always a good
thing. Sure the piece of code you are looking at could be perfect. But, some
other piece of code which you have never seen could be doing things in a way
that breaks your code.

[2](http://cs.oswego.edu/pipermail/concurrency-interest/2011-November/008377.html)
"Always call wait/await in a loop. If you don't, you will have mysterious
failures in production."