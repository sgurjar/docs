## How many threads in parallel stream?

````.java
    if (args.length > 0) {
      int n = Integer.parseInt(args[0]);
      System.out.println("setting parallelism=" + n);
      // ForkJoinPool.commonPool is init once in static-init, 
      // we can't reset number of threads in this pool after its created.
      System.setProperty("java.util.concurrent.ForkJoinPool.common.parallelism", String.valueOf(n));
    }
    System.out.println("how many threads in parallel stream:"
        + " ncpu=" + Runtime.getRuntime().availableProcessors()
        + " parallelism=" + System.getProperty("java.util.concurrent.ForkJoinPool.common.parallelism") + " "
        + IntStream.range(1, 1_000_000).parallel()
                                       .map(i -> Thread.currentThread().hashCode())
                                       .distinct()
                                       .count());
````
