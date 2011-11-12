Item 66: Synchronize access to shared mutable data
--------------------------------------------------

2 things to take care with shared data, 1) *publication*, 2) *mutual exclusion*.


        public class StopThread {
          private static boolean stopRequested;

          public static void main(String[] args)
                      throws InterruptedException {
            Thread backgroundThread = new Thread(new Runnable() {
                                                  public void run() {
                                                    int i = 0;
                                                    while (!stopRequested)
                                                    i++;
                                                  }
                                                });
            backgroundThread.start();
            TimeUnit.SECONDS.sleep(1);
            stopRequested = true;
          }
        }

The problem is that in the absence of synchronization, there is no guarantee as
to when, if ever, the background thread will see the change in the value of
`stopRequested` that was made by the main thread.

In the absence of synchronization, it’s quite acceptable for the virtual
machine to transform this code:

        while (!done)
          i++;

into this code:

        if (!done)
          while (true)
              i++;

This optimization is known as *hoisting*, and it is precisely what the HotSpot
server VM does. The result is a *liveness failure: the program fails to make
progress*.

One way to fix the problem is to synchronize access to the `stopRequested` field.
This program terminates in about one second, as expected:

        // Properly synchronized cooperative thread termination
        public class StopThread {
          private static boolean stopRequested;

          private static synchronized void    requestStop  () {stopRequested = true;}
          private static synchronized boolean stopRequested() {return stopRequested;}

          public static void main(String[] args) throws InterruptedException {

            Thread backgroundThread = new Thread(new Runnable() {
              public void run() {
                int i = 0;
                while (!stopRequested())
                i++;
              }
            });

            backgroundThread.start();
            TimeUnit.SECONDS.sleep(1);
            requestStop();
          }
        }

It is __not__ sufficient to synchronize only the write method! In fact,
synchronization has __no effect__ unless both __read__ and __write__ operations
are *synchronized*.

The actions of the synchronized methods in `StopThread` would be atomic even
__without__ synchronization, as all the 32 bits (4 bytes) or less data types on
a 32-bit machine are atomically written and read. The synchronization on these
methods is used solely for its __communication effects, not for mutual exclusion__.
It asks VM to not to reorder instructions and execute in same order as written.

### Using `volatile`

While the `volatile` modifier performs no mutual exclusion, it guarantees that
any thread that reads the field will see the __most recently__ written value,
ensures publication.


    // Cooperative thread termination with a volatile field
    public class StopThread {
      private static volatile boolean stopRequested;

      public static void main(String[] args)
                  throws InterruptedException {
        Thread backgroundThread = new Thread(new Runnable() {
                                          public void run() {
                                          int i = 0;
                                          while (!stopRequested)
                                          i++;
                                        }
                                      });
        backgroundThread.start();
        TimeUnit.SECONDS.sleep(1);
        stopRequested = true;
      }
    }

`volatile` can only work if writing the value doesnt depend on it existing value.
Following example is broken for same reason:

    // Broken - requires synchronization!
    private static volatile int nextSerialNumber = 0;
    public static int generateSerialNumber() {return nextSerialNumber++;}

here `nextSerialNumber++` requires to read existing value in order to increment
it. Two or more threads can reads same value and return same number.

One way to fix the `generateSerialNumber` method is to add the `synchronized`
modifier to its declaration. This ensures that multiple invocations won’t be
interleaved, and that each invocation will see the effects of all previous
invocations. Once you’ve done that, you can and should remove the volatile
modifier from nextSerialNumber.

###Using `j.u.c.atomic`

`AtomicXXX` classes in [`java.util.concurrent.atomic`](http://download.oracle.com/javase/1,5.0/docs/api/java/util/concurrent/atomic/package-summary.html)
have methods like following:

        addAndGet(delta)              // adds the given value to the current value
        compareAndSet(expect, update) // sets the value to the given updated value if the current value == the expected value.
        getAndAdd(delta)              // adds the given value to the current value.
        decrementAndGet()             // decrements by one the current value
        getAndDecrement()             // decrements by one the current value.
        getAndSet(newval)             // sets to the given value and returns the old value.

These methods ensures atomic modifications to a variable even when it is required
to read the existing value of the value.

### There are many ways to safely publish an object reference:

  * store it in a `static` field as part of class initialization
  * store it in a `volatile` field, a `final` field
  * a field that is accessed with normal locking
  * put it into a concurrent collection