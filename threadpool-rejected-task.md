1. When a new task is submitted in method `execute(Runnable)`, and fewer than `corePoolSize` threads 
   are running, a __new thread__ is created to handle the request, even if other worker threads are idle. 
2. If there are more than `corePoolSize` but less than `maximumPoolSize` threads running, 
   a new thread will be created __only if the queue is full__.

### And if
There are `maximumPoolSize` threads are running and queue is full then new tasks are rejected and 
`RejectedExecutionHandler.rejectedExecution(Runnable, ThreadPoolExecutor)` is called.

### Order is
1. Run up to `corePoolSize` threads first.
2. Add any  new tasks to `workQueue`.
3. If `workQueue` is full, for each new task create new thread up to `maximumPoolSize` threads.
4. If `maximumPoolSize` threads are running and `workQueue` is full __reject__ the task and call `RejectedExecutionHandler`.

### Example

```
corePoolSize=8 
maximumPoolSize=16 
workQueueSize=32

submitting task# 42 CorePoolSize=8 MaximumPoolSize=16 PoolSize=8  LargestPoolSize=8  ActiveCount=8  QueuedTasks=29 InProgressTasks=37
submitted  task# 42 CorePoolSize=8 MaximumPoolSize=16 PoolSize=8  LargestPoolSize=8  ActiveCount=8  QueuedTasks=30 InProgressTasks=38
submitting task# 43 CorePoolSize=8 MaximumPoolSize=16 PoolSize=8  LargestPoolSize=8  ActiveCount=8  QueuedTasks=30 InProgressTasks=38
submitted  task# 43 CorePoolSize=8 MaximumPoolSize=16 PoolSize=8  LargestPoolSize=8  ActiveCount=8  QueuedTasks=31 InProgressTasks=39
submitting task# 44 CorePoolSize=8 MaximumPoolSize=16 PoolSize=8  LargestPoolSize=8  ActiveCount=8  QueuedTasks=31 InProgressTasks=39
submitted  task# 44 CorePoolSize=8 MaximumPoolSize=16 PoolSize=8  LargestPoolSize=8  ActiveCount=8  QueuedTasks=32 InProgressTasks=40
submitting task# 45 CorePoolSize=8 MaximumPoolSize=16 PoolSize=8  LargestPoolSize=8  ActiveCount=8  QueuedTasks=32 InProgressTasks=40
submitted  task# 45 CorePoolSize=8 MaximumPoolSize=16 PoolSize=9  LargestPoolSize=9  ActiveCount=9  QueuedTasks=32 InProgressTasks=41
submitting task# 46 CorePoolSize=8 MaximumPoolSize=16 PoolSize=9  LargestPoolSize=9  ActiveCount=9  QueuedTasks=32 InProgressTasks=41
submitted  task# 46 CorePoolSize=8 MaximumPoolSize=16 PoolSize=10 LargestPoolSize=10 ActiveCount=10 QueuedTasks=32 InProgressTasks=42
submitting task# 47 CorePoolSize=8 MaximumPoolSize=16 PoolSize=10 LargestPoolSize=10 ActiveCount=10 QueuedTasks=32 InProgressTasks=42
submitted  task# 47 CorePoolSize=8 MaximumPoolSize=16 PoolSize=11 LargestPoolSize=11 ActiveCount=11 QueuedTasks=32 InProgressTasks=43
submitting task# 48 CorePoolSize=8 MaximumPoolSize=16 PoolSize=11 LargestPoolSize=11 ActiveCount=11 QueuedTasks=32 InProgressTasks=43
submitted  task# 48 CorePoolSize=8 MaximumPoolSize=16 PoolSize=12 LargestPoolSize=12 ActiveCount=12 QueuedTasks=32 InProgressTasks=44
submitting task# 49 CorePoolSize=8 MaximumPoolSize=16 PoolSize=12 LargestPoolSize=12 ActiveCount=12 QueuedTasks=32 InProgressTasks=44
submitted  task# 49 CorePoolSize=8 MaximumPoolSize=16 PoolSize=13 LargestPoolSize=13 ActiveCount=13 QueuedTasks=32 InProgressTasks=45
submitting task# 50 CorePoolSize=8 MaximumPoolSize=16 PoolSize=13 LargestPoolSize=13 ActiveCount=13 QueuedTasks=32 InProgressTasks=45
submitted  task# 50 CorePoolSize=8 MaximumPoolSize=16 PoolSize=14 LargestPoolSize=14 ActiveCount=14 QueuedTasks=32 InProgressTasks=46
submitting task# 51 CorePoolSize=8 MaximumPoolSize=16 PoolSize=14 LargestPoolSize=14 ActiveCount=14 QueuedTasks=32 InProgressTasks=46
submitted  task# 51 CorePoolSize=8 MaximumPoolSize=16 PoolSize=15 LargestPoolSize=15 ActiveCount=15 QueuedTasks=32 InProgressTasks=47
submitting task# 52 CorePoolSize=8 MaximumPoolSize=16 PoolSize=15 LargestPoolSize=15 ActiveCount=15 QueuedTasks=32 InProgressTasks=47
submitted  task# 52 CorePoolSize=8 MaximumPoolSize=16 PoolSize=16 LargestPoolSize=16 ActiveCount=16 QueuedTasks=32 InProgressTasks=48
submitting task# 53 CorePoolSize=8 MaximumPoolSize=16 PoolSize=16 LargestPoolSize=16 ActiveCount=16 QueuedTasks=32 InProgressTasks=48
RejectedExecutionHandler Task#53 CorePoolSize=8 MaximumPoolSize=16 PoolSize=16 LargestPoolSize=16 ActiveCount=16 QueuedTasks=32 InProgressTasks=48
```

### Test Code

```java
import java.io.Closeable;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.Executors;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.RejectedExecutionHandler;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.Function;

/* to run

    nohup java -ea \
    -Dmin.threads=8 \
    -Dmax.threads=16 \
    -Dqueue.size=32 \
    -Dnum.tasks=64 \
    Test_ThreadPoolExecutor_RejectedExecutionHandler &>t.out </dev/null &
*/

public class Test_ThreadPoolExecutor_RejectedExecutionHandler
{
    static void log(final String msg) { System.out.println(LocalDateTime.now() + " [" + Thread.currentThread().getName() + "] " + msg); }

    public static void main(final String[] args)
    {
        final CountDownLatch latch = new CountDownLatch(1);

        log("started use 'kill -2 pid' to stop");
        Runtime.getRuntime().addShutdownHook(new Thread(latch::countDown, "shutdownhook-thread"));

        final int minThreads = Integer.parseInt(System.getProperty("min.threads",   "5").trim()); assert minThreads > 0;
        final int maxThreads = Integer.parseInt(System.getProperty("max.threads",  "10").trim()); assert maxThreads > 0;
        final int queueSize  = Integer.parseInt(System.getProperty("queue.size" ,  "16").trim()); assert queueSize  > 0;
        final int numTasks   = Integer.parseInt(System.getProperty("num.tasks"  , "100").trim()); assert numTasks   > 0;

        log("minThreads=" + minThreads + " maxThreads=" + maxThreads + " queueSize=" + queueSize + " numTasks=" + numTasks);

        try (Closeable t = test_00(minThreads, maxThreads, queueSize, numTasks))
        {
            log("await");
            try { latch.await(); } catch (final InterruptedException e) { e.printStackTrace(); }
        }
        catch (final IOException e) { e.printStackTrace(); }
        finally { log("done!"); }
    }

    interface Task extends Runnable { int getId(); }

    static Closeable test_00(final int minThreads, final int maxThread, final int queueSize, final int ntasks)
    {
        final RejectedExecutionHandler handler = (task, threadpool) -> {
            log("RejectedExecutionHandler Task#" + ((Task) task).getId() + " " + getThreadPoolMetrics(threadpool));
        };
        final AtomicInteger n = new AtomicInteger();
        final ThreadFactory tf = (runnable) -> {
            final Thread t = new Thread(runnable);
            t.setName("test-rh-pool-" + n.incrementAndGet());
            t.setDaemon(true);
            return t;
        };
        final ThreadPoolExecutor pool = new ThreadPoolExecutor(
                minThreads,
                maxThread,
                Long.MAX_VALUE, TimeUnit.MILLISECONDS,
                new LinkedBlockingQueue<>(queueSize),
                tf,
                handler);

        final ScheduledExecutorService reporter = Executors.newScheduledThreadPool(1);
        reporter.scheduleWithFixedDelay(() -> {log("monitor " + getThreadPoolMetrics(pool));}, 5, 5, TimeUnit.SECONDS);

        final Function<Integer, Task> makeTask = (i) -> {
            return new Task()
            {
                @Override public int getId() { return i; }

                @Override
                public void run()
                {
                    final long timeout = ThreadLocalRandom.current().nextInt(100, 1000);
                    try
                    {
                        log("task# " + i + " sleeping for " + timeout + " ms");
                        TimeUnit.MILLISECONDS.sleep(timeout);
                        log("task# " + i + " wokeup after " + timeout + " ms");
                    }
                    catch (final InterruptedException e) { e.printStackTrace(); }
                };
            };
        };

        for (int i = 0; i < ntasks; i++) {
            log("submitting task# " + i + " " + getThreadPoolMetrics(pool));
            pool.execute(makeTask.apply(i));
            log("submitted task# " + i + " " + getThreadPoolMetrics(pool));
            sleep(10, TimeUnit.MILLISECONDS);
        }

        return () -> { reporter.shutdownNow(); };
    }

    static void sleep(final long timeout, final TimeUnit unit)
    {
        try { unit.sleep(timeout); } catch (final InterruptedException e) { }
    }

    static String getThreadPoolMetrics(final ThreadPoolExecutor pool)
    {
        final long inprogressTaskCount = pool.getTaskCount() - pool.getCompletedTaskCount();
        return "CorePoolSize=" + pool.getCorePoolSize()
                + " MaximumPoolSize=" + pool.getMaximumPoolSize()
                + " PoolSize=" + pool.getPoolSize()
                + " LargestPoolSize=" + pool.getLargestPoolSize()
                + " ActiveCount=" + pool.getActiveCount()
                + " QueuedTasks=" + pool.getQueue().size()
                + " InProgressTasks=" + inprogressTaskCount;
    }
}
```
