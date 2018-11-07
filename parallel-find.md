## Parallel find using ForkJoin

````.java
import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.RecursiveAction;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class ParallelFind {
  public static void main(String[] args) {
    long t0 = System.nanoTime();
    try {
      Map<String, String> argv = Stream.of(args).map(s -> s.split("="))
            .collect(Collectors.toMap(a -> a[0].trim(), a -> a.length > 1 ? a[1].trim() : ""));
      System.err.println(LocalDateTime.now() + "] args: " + argv);
      Function<String, String> getOrFail = key -> {
        String v = argv.get(key);
        if (v == null || v.isEmpty()) throw new RuntimeException("'" + key + "' is missing");
        return v;
      };
      File rootdir = new File(getOrFail.apply("dir"));
      long mtime = mtime(getOrFail.apply("mtime"));
      File logdir = new File(getOrFail.apply("logdir"));
      int nsplit = Integer.parseInt(getOrFail.apply("split"));
      if (logdir.exists() && !logdir.isDirectory()) throw new RuntimeException(logdir + " is not a dir");
      if (!logdir.exists()) logdir.mkdirs();
      ParallelFind pf = new ParallelFind(mtime, logdir, nsplit);
      pf.invoke(rootdir);
    } finally {
      System.err.println(LocalDateTime.now() + "] elapsed " 
        + TimeUnit.NANOSECONDS.toSeconds(System.nanoTime() - t0) + " seconds");
    }
  }

  static long mtime(String mtime) {
    Calendar cal = Calendar.getInstance();
    cal.setTimeInMillis(System.currentTimeMillis());
    cal.set(Calendar.HOUR_OF_DAY, 0);
    cal.set(Calendar.MINUTE, 0);
    cal.set(Calendar.SECOND, 0);
    cal.set(Calendar.MILLISECOND, 0);
    long mtime_ms = Integer.parseInt(mtime) * 24 * 60 * 60 * 1000;
    if (cal.getTimeInMillis() < mtime_ms) throw new AssertionError();
    cal.setTimeInMillis(cal.getTimeInMillis() - mtime_ms);
    return cal.getTimeInMillis();
  }


  int nsplit;
  long mtime;
  File logdir;
  AtomicInteger seq;
  ForkJoinPool pool = new ForkJoinPool();

  ParallelFind(long mtime, File logdir, int nsplit) {
    this.mtime = mtime;
    this.logdir = logdir;
    this.seq = new AtomicInteger();
    this.pool = new ForkJoinPool(Math.min(0x7fff, Runtime.getRuntime().availableProcessors()),
                  ForkJoinPool.defaultForkJoinWorkerThreadFactory,
                  (thread, throwable) -> {System.err.println("error in thread " + thread + ": " + throwable);},
                  true);
    this.nsplit = nsplit;
  }

  void invoke(File rootdir) {
    if (!rootdir.isDirectory()) throw new IllegalArgumentException(rootdir + " must be a dir");
    pool.invoke(new DirectoryAction(rootdir));
    pool.awaitQuiescence(30, TimeUnit.SECONDS);
  }

  @SuppressWarnings("serial")
  final class FilesAction extends RecursiveAction {
    private final List<File> files;
    private File logfile;

    FilesAction(List<File> files_) {
      files = files_;
      logfile = new File(ParallelFind.this.logdir, String.format("part-%04d", ParallelFind.this.seq.getAndIncrement()));
    }

    @Override
    protected void compute() {
      File f;
      try (PrintWriter writer = new PrintWriter(logfile)) {
        for (int i = 0; i < files.size(); i++) {
          f = files.get(i);
          if (f.lastModified() <= ParallelFind.this.mtime) {
            writer.println(f);
          }
        }
      } catch (FileNotFoundException e) {
        System.err.println(e);
      }
    }
  }

  @SuppressWarnings("serial")
  final class DirectoryAction extends RecursiveAction {
    private final File dir;

    DirectoryAction(File dir_) { dir = dir_; }

    @Override
    protected void compute() {
      String[] children = dir.list();
      List<File> files = new ArrayList<>();
      File f;
      for (int i = 0; i < children.length; i++) {
        f = new File(dir, children[i]);
        if (f.isDirectory()) {
          new DirectoryAction(f).fork();
        } else if (f.isFile()) {
          files.add(f);
          if (files.size() >= ParallelFind.this.nsplit) {
            new FilesAction(files).fork();
            files = new ArrayList<>();
          }
        } else {
          throw new AssertionError("who are you? " + f);
        }
      }
      if (!files.isEmpty())
        new FilesAction(files).fork(); // tail end
    }
  }
}
````
