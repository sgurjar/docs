```console
$dstat -lrvn 10
---load-avg--- --io/total- ---procs--- ------memory-usage----- ---paging-- -dsk/total- ---system-- ----total-cpu-usage---- -net/total-
 1m   5m  15m | read  writ|run blk new| used  buff  cach  free|  in   out | read  writ| int   csw |usr sys idl wai hiq siq| recv  send
0.02 0.02 0.05|0.06  0.88 |  0   0 1.3|15.1G  445M 10.5G  981G|   0     0 |2932B 6198B| 933   786 |  0   0 100   0   0   0|   0     0
0.02 0.02 0.05|   0  0.80 |  0   0 0.8|15.1G  445M 10.5G  981G|   0     0 |   0  4096B| 544   230 |  0   0 100   0   0   0| 665B 1641B
0.02 0.02 0.05|   0  0.70 |  0   0 0.8|15.1G  445M 10.5G  981G|   0     0 |   0  3277B| 587   214 |  0   0 100   0   0   0| 744B 1203B
0.01 0.02 0.05|   0  0.80 |  0   0 0.8|15.1G  445M 10.5G  981G|   0     0 |   0  4096B| 542   226 |  0   0 100   0   0   0| 620B 1159B
0.01 0.02 0.05|   0  0.70 |  0   0 0.9|15.1G  445M 10.5G  981G|   0     0 |   0  3277B| 524   212 |  0   0 100   0   0   0| 682B 1098B
```

```text
Here options passed are:
  -l  load average
  -r  disk IOPS
  -v  vmstats
  -n  network throughput
  10  refresh every 10 seconds
```

* On a fully warmed-up system, memory should be around 95% in-use,
  with most of it in the cache column.
* CPUs should be in use with no more than 1-2% of iowait and 2-15% system time.
* The network throughput should mirror whatever the application is doing,
  so if it's cassandra-stress, it should be steady. If it's a Hadoop job
  writing in big batches, expect big spikes.


### `---procs--- run blk new`

* These show how many processes or threads were running/blocked/created
  during the sample window. `run=~n_cores` is ideal for ROI/efficiency,
  but makes a lot of admins nervous. `run=2*n_cores` isn't necessarily
  bad. `run>cores` is healthy with some head room.

* Any blocked processes is considered bad and you should immediately
  look at the `iowait %`. `1-2% iowait` isn't necessarily a problem,
  but it usually points at storage as a __bottleneck__.

### `------memory-usage-----`

* `used` will usually be your `heap + offheap + ~500MB`.
* `buff` Buffers should be a couple hundred MB, rarely more than a gigabyte.
* `cach` account for almost all the remaining memory if data > RAM.
* `free` should be in the 200-300MB range unless the working data size is smaller than installed memory.

### `----swap---  used  free`

* These should always be zeros.
* Any swap activity whatsoever is a source of hiccups and must be eliminated before anything else.

### `-dsk/total- read  writ`

* read/write bytes __per second__

### `---system--` interrupts (`int`) and context switches (`csw`)
* An interrupt occurs when a device needs the CPU to do something, such as pick up data from the network or disks.
* Context switches occur when the kernel has to switch out a task on the CPU.
* Most interrupts are tied to a `ctx`, which is why `ctx` is almost always `> interrupts`.
* On a healthy system, `ctx` should be `20-40%` __higher__ than `interrupts`.
* If it's a lot higher, take a look at system call counts with `strace`.
* `futex` is almost always the top call and indicates a high amount of lock contention.

### `----total-cpu-usage----`
* `usr` CPU time used to run userland processes, i.e. JVM threads.
* `sys` System time is time spent in kernel code.
* `idl` Idle time
* `wai`
* `hiq/siq` are for time spent processing hardware and soft interrupts.
  These are usually zeroes but you'll occasionally see `siq` time under heavy load.
  A few % is fine. Any more indicates a serious problem with the kernel and/or hardware.

### `-net/total-`
* `recv/send` Shows the amount of data flowing over the network.

The differential between network / disk io / CPU usage gives a good picture of how efficiently a system is running.

To output results to a file use

```text
--output file
    write CSV output to file
```

## All Options

```text
-c, --cpu                   enable cpu stats (system, user, idle, wait, hardware interrupt, software interrupt) 
-C 0,3,total                include cpu0, cpu3 and total 
-d, --disk                  enable disk stats (read, write) 
-D total,hda                include hda and total 
-g, --page                  enable page stats (page in, page out) 
-i, --int                   enable interrupt stats 
-I 5,10                     include interrupt 5 and 10 
-l, --load                  enable load average stats (1 min, 5 mins, 15mins) 
-m, --mem                   enable memory stats (used, buffers, cache, free) 
-n, --net                   enable network stats (receive, send) 
-N eth1,total               include eth1 and total 
-p, --proc                  enable process stats (runnable, uninterruptible, new) 
-r, --io                    enable I/O request stats (read, write requests) 
-s, --swap                  enable swap stats (used, free) 
-S swap1,total              include swap1 and total 
-t, --time                  enable time/date output 
-T, --epoch                 enable time counter (seconds since epoch) 
-y, --sys                   enable system stats (interrupts, context switches) 
--aio                       enable aio stats (asynchronous I/O)
--fs                        enable filesystem stats (open files, inodes)
--ipc                       enable ipc stats (message queue, semaphores, shared memory)
--lock                      enable file lock stats (posix, flock, read, write)
--raw                       enable raw stats (raw sockets)
--socket                    enable socket stats (total, tcp, udp, raw, ip-fragments) 
--tcp                       enable tcp stats (listen, established, syn, time_wait, close)
--udp                       enable udp stats (listen, active)
--unix                      enable unix stats (datagram, stream, listen, active)
--vm                        enable vm stats (hard pagefaults, soft pagefaults, allocated, free)
--list                      list the internal and external plugin names
-a, --all                   equals -cdngy (default) 
-f, --full                  expand -C, -D, -I, -N and -S discovery lists 
-v, --vmstat                equals -pmgdsc -D total 
--bw, --blackonwhite        change colors for white background terminal 
--float                     force float values on screen (mutual exclusive with --integer) 
--integer                   force integer values on screen (mutual exclusive with --float) 
--nocolor                   disable colors (implies --noupdate) 
--noheaders                 disable repetitive headers 
--noupdate                  disable intermediate updates when delay > 1 
--output file               write CSV output to file 
```

## References
* [tobert.github.io/pages/als-cassandra-21-tuning-guide.html](https://tobert.github.io/pages/als-cassandra-21-tuning-guide.html)
* [linux.die.net/man/1/dstat](https://linux.die.net/man/1/dstat)
