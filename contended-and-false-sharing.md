http://robsjava.blogspot.com/2014/03/what-is-false-sharing.html

# @Contended and False Sharing #

## Cache Line Overview
CPU's don't read memory in single bytes, rather they read 'chunks of
memory' usually in blocks of 64 bytes, these chunks are referred to as
cache lines.

If you had two threads ( let's call them Thread 1 and Thread 2  ) both
modifying a volatile variable, which we shall call `x' :

```java
    volatile long x;
```

If Thread 1 was to change the value of `x`, and then Thread 2  was to
read it :

```java
    Thread 1: x=3;

    Thread 2: System.out.print(x);
```

For the value of `x` to be passed between the two threads ( Thread 1 to
Thread 2 ) a whole 64 bytes will be exchanged, as cores only exchange
data in cache lines. It is possible that Thread 1 and Thread 2, may
actually be processed on the same core, but for this over simplified
example lets assume that each thread is processed on its own core.


Given that long values are stored in 8 bytes, and in our example our cache
line is 64 bytes, then the cache line could store 8 longs, we already
have one long value of `x` stored in the cache line, lets assume that
the rest of the cache line was full of 7 other longs, for example `v1` to `v7`

```java
    x, v1, v2, v3, v4, v5 ,v6 ,v7
```

## False Sharing ## 
This cache line could be used by a number of different threads. If
another thread was to modify `v2`, this would then force Thread 1 and
Thread 2 to reload the cache line. You maybe wondering why should Thread
1 and Thread 2 reload this cache line, as the update to `v2` should not
affect them. Well, even though these updates are logically independent
of each other, coherence is maintained on a cache-line basis, and not
on individual elements. This apparent unnecessary sharing of data is
referred to as false sharing.

## Padding ## 
A core can execute hundreds of instructions in the time taken to fetch
a single cache line.

If a core has to wait for a cache line to be reloaded, the core will
run out of things to do, this is called a stall. Stalls can be avoided
by reducing false sharing, one technique to reduce false sharing is to
pad out data structure so that threads working on independent variables
fall in separate cache lines.


An example of a padded class, attempting to place `x` and `v1` on separate
cache lines :

```java
public class FalseSharingWithPadding {

    public volatile long x;
    public volatile long p2;   // padding
    public volatile long p3;   // padding
    public volatile long p4;   // padding
    public volatile long p5;   // padding
    public volatile long p6;   // padding
    public volatile long p7;   // padding
    public volatile long p8;   // padding
    public volatile long v1;
}
```

Before you go ahead an pad all your data structures its worth bearing
in mind that the JVM can eliminate or re-order unused fields, thus
re-introducing false sharing. Also there is no guarantee where objects
will be placed on the heap.


To reduce the chance of your unused padding fields from being eliminated,
it usually helps if you set them volatile. I suggest you only apply
padding to highly contended concurrent classes and then, only if profiling
on your target architecture, actually shows a difference. Usually best
to do this after at least 10,000 iterations, to eliminate the effects
of JVM realtime optimisations.

## Java 8 and `@Contended` ## 
Rather than introduce padding fields a cleaner approach would be to
annotate the fields that were likely to fall victim to false sharing,
this could act as a hint to the JVM, which could split your fields into
separate cache lines. This is the aim of JEP 142.


This JEP introduces the `@Contended` annotation. This annotation serves as
a hint that such objects and fields should reside in locations isolated
from those of other objects or fields

```java
public class Point {

    int x;

    @Contended

    int y;
}
```


The code above will place both `x` and `y` on separate cache lines. The
`@Contended` __shifts__ the `y` field away from the object header.

## References
* http://openjdk.java.net/projects/jdk8/features
* http://beautynbits.blogspot.co.uk/2012/11/the-end-for-false-sharing-in-java.html
* http://openjdk.java.net/jeps/142
* http://mechanical-sympathy.blogspot.co.uk/2011/08/false-sharing-java-7.html
* http://stackoverflow.com/questions/19892322/when-will-jvm-use-intrinsics
* https://blogs.oracle.com/dave/entry/java_contented_annotation_to_help
