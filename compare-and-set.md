Title: Notes on java concurrency
Date: 8/8/2012


compareAndSet
-------------

Increment an `AtomicInteger` variable

        for (;;) {
            int current = v.get();
            int next = current + 1;
            if (compareAndSet(current, next))
                return next;
        }

compareAndSet returns false if actual value is not equal (`==`) to `current`. To
update the value you need to get current value and call CAS with current value
and new value, if current value is not updated between calling `get()` and
`compareAndSet()` it will be updated and published to all the threads who are
trying to access it value using `get()` or similar operations (`getAndIncrement`)

thread keep try to update the variable in infinite loop, and breaks when
compareAndSet succeeds, this is lock free update that ensures mutual exclusion
and publication both.

        for (;;) {
            int current = v.get();
            int next = current + 1;
            if (compareAndSet(current, next))   // 1
                return v.get();                 // 2. try to get current value from v
        }

This will not work if you are expecting uniqe values from a function as between
CAS [1] and v.get() [2] value of v might have changed then 2 calls of the function
can return same value.

`AtomicReference.compareAndSet` uses `==` to match the current value to actual value
not `equals`. In case of `AtomicReference`, `compareAndSet` will succeed if
refernces are `==`

The `AtomicIntegerArray`, `AtomicLongArray`, and `AtomicReferenceArray` classes
further extend atomic operation support to arrays of these types. These classes
are also notable in providing volatile access semantics for their array elements,
which is not supported for ordinary arrays.

The AtomicXArray classes have atomically accessed elements. volatile arrays do
not have special memory semantics for reads and writes of their
elements -- only the reference to the array is atomic.

    volatile int[] a = new int[10];

only make refernce a as volatile, not the elements of a volatile. There is no
way in java to make elemnts of array volatile, unless use `AtomicXArray`

However `AtomicXArray` has no lock, it only provides volatile semtics per element
of the array, that is backed array (int[] a in case of AtomicIntegerArray and
Object[] in case of AtomicReferenceArray) is never locked as whole.

## same volatile must write and read to ensure visibility
__Important Note:__ Note that it is important for both threads to access the same
volatile variable in order to properly set up the happens-before relationship.
It is not the case that everything visible to thread A when it writes volatile
field f becomes visible to thread B after it reads volatile field g. The release
and acquire have to "match" (i.e., be performed on the same volatile field) to
have the right semantics.

* _writing to a volatile variable won't necessarily flush values to memory unless
there is a subsequent read of that __same__ volatile variable._

The visibility effects of volatile only apply when you have a read of a field
following a write of that field. Successive reads of a field don't have
any special properties.

The only "happens-before" property that volatile has is as follows:

* a volatile write happens-before a __subsequent__ volatile __read__ of the value __written__.

then how about following


    volatile int []arr;

    public void setValue( int idx, int val ) {
        arr[idx] = val;
        arr = arr;  // volatile read and write
    }

    public int getValue( int idx ) {
        arr = arr; // volatile read and write
        return arr[ idx ];
    }

Would that make elemtens of `arr` behave like volatile, or compiler will remove
no-ops ?

> The compiler might remove the "no-op assignment" but it isn't allowed to
> remove the associated memory model actions. So even if the store is elided
> the "memory barriers" that might be needed would still have to occur.
> [Volatile and primitive arrays](http://cs.oswego.edu/pipermail/concurrency-interest/2008-May/005243.html)

## double-checked locking:

        class Foo {
            private volatile Helper helper = null;
            public Helper getHelper() {
                if (helper == null) {
                    synchronized(this) {
                            // double check after helper is being read from memory
                            // due to synchronized(this)
                            if (helper == null)
                                helper = new Helper();
                        }
                }
                return helper;
            }
        }

This allows the reader not to synchronize when the object has already been
constructed. The synchronization is necessary for mutual exclusion; it makes
sure that the helper field is null when the object is constructed and the
field is assigned its value.

## `final` and partially constructed objects

An object is considered to be completely initialized when its constructor
finishes. A thread that can only see a reference to an object __after__ that
object has been completely initialized is guaranteed to see the correctly
initialized values for that object's __final__ fields (not non-final fields).

            class FinalFieldExample {
              final int x;
              int y;
              static FinalFieldExample f;
              public FinalFieldExample() {
                x = 3;
                y = 4;
              }
              static void writer() {
                f = new FinalFieldExample();
              }
              static void reader() {
                if (f != null) {
                  int i = f.x; // guaranteed to see 3
                  int j = f.y; // could see 0, default value <<<<<<<<<<<<<<
                }
              }
            }

The class FinalFieldExample has a final int field x and a non-final int field y.
One thread might execute the method writer(), and another might execute the method reader().

Because writer() writes f after the object's constructor finishes, the reader()
will be guaranteed to see the properly initialized value for f.x:
it will read the value 3. However, f.y is not final; the reader() method is
therefore __not__ guaranteed to see the value 4 for it.

Construction of an object has 2 parts-

 1. create memory for an object and zero it out
 2. invoke constructor to initialize the data members.

processors are not required to flush part2 in main memory and if object
is published with data race, another thread might __not__ see work done in part2
if data member is __not final__ (that is will see partially constructed object).

[JLS on final field semantics](http://docs.oracle.com/javase/specs/jls/se5.0/html/memory.html#17.5 "17.5 Final Field Semantics")

> Let `o` be an object, and `c` be a constructor for `o` in which `f` is written.
> A _freeze_ action on a final field `f` of `o` takes place when `c` exits,
> either normally or abruptly.

* __Dereference Chain__ If an action `a` is a read or write of a field or
element of an object `o` by a thread `t` that did not initialize `o`,
then there must exist some read `r` by thread `t` that sees the address
of `o` such that `r` `dereferences(r, a)`.

  In other words, if a thread `t` reads or write a field of an object `o` that
did not initialized `o`, then thread must have read object `o` at some point (
or by some dereferencing chain).

* __Memory Chain__
    + if `r` is a read that sees a write `w`, then it must be the case
      that `mc(w, r)`.
    + If `r` and `a` are actions such that `dereferences(r, a)`,
      then it must be the case that `mc(r, a)`.
    + If `w` is a write of the address of an object `o` by a thread `t` that 
      did not initialize `o`, then there must exist some read `r` by thread `t` 
      that sees the address of `o` such that `mc(r, w)`. 

<pre>
Given
    a write  w
    a freeze f
      action a      (that is not a read of a final field)
    a read   r1     of the final field frozen by `f`
    a read   r2     such that hb(w, f), hb(f, a), mc(a, r1) and dereferences(r1 , r2)
</pre>

* Thread 1
  - initialize an object at address X,
  - Make Foo.x reference the object at address X

* Thread 2
  - reads Foo.x, gets X
  - reads field of object at address X, sees preinitialization value

* We could put a memory barrier after object initialization
  - but that isn't enough
  - need a memory barrier for reading processor

* Allocate objects out of memory that everyone agrees has been zeroed 
  - since memory was zeroed, every processor must have done a memory barrier

* Class loading safety
  - Current spec says that before executing `getstatic`, `putstatic`, 
      `invokestatic` or `new` on a class, you must load the class or verify that
      another class has loaded it
  - Add: if you verify that another class has loaded it, you must do an acquire 
      so as to see all writes by the thread that initialized it
  - Add invokevirtual, invokespecial, getfield, putfield

* semantics of final
    - Under current semantics, a memory barrier effects final fields
      + forces them to be reloaded from memory
    - Change semantics to allow them to remain in registers
      + also across unknown method calls
    - Ugly if objects escapes constructor before final fields initialized

### Why aren't Strings immutable?

- A String object is initialized to have default values for it's fields
- Then the fields are set in the constructor
- Thread 1 could create a String object
- pass it to Thread 2
- which calls a sensitive routine
- which sees the fields change from their default values to their final values

__Discussion__
    
        Thread_1
                Global.s = "/tmp/usr".substring(4);
        
        Thread_2
                String myS = Global.s;
                if (myS.equals("/tmp"))System.out.println(myS);

`String` objects are intended to be immutable and string operations do 
not perform synchronization. 

if the fields of the `String` class were not `final`, then it would be possible 
(although unlikely) that `Thread_2` could initially see the default value of 
0 for the `offset` of the string object, allowing it to compare as equal to 
"/tmp". A later operation on the String object might see the correct offset of 
4, so that the String object is perceived as being "/usr". 

            public String substring (int start) {
                return new String(offset + start, count - start, value);
                // ignoring error checks
            }

### Making String immutable
    
#### Atomic object creation
##### object creation is __NOT__ atomic
            
         p = new P(1,2);
         // start 2 threads; t1 t2

         t1                   |     t2
         ----------------------------------
         p = new Point(3,4)   |     a = p.x

         // In this code, a could get the value 1, 3 or 0


##### Should object creation be atomic?
- Simple approach would require memory barriers in front  of each `getfield`

##### Solution
- Guarantee that reads of final fields see the final value, not the initial default value
  + assuming object doesnot escape before final fields set
- Might be much cheaper than full atomic object creation
- No way for elements of an array to be final
- For Strings, have to see final values for elements of character array
- Read of final field is treated as a weak acquire
  + matching a release done when object is constructed
- weak in that it only effects things dependent on value read
    

## [JMM FAQ](http://www.cs.umd.edu/~pugh/java/memoryModel/jsr-133-faq.html "JSR 133 (Java Memory Model) FAQ")

* At the processor level, a memory model defines necessary and sufficient
conditions for knowing that writes to memory by other processors are
__visible__ to the current processor, and writes by the current processor
are visible to other processors.

* __memory barriers__, are required to flush or invalidate the local processor
cache in order to see writes made by other processors or make writes by
this processor visible to others.

* __compiler's reordering of code__, The issue of when a write becomes visible
to another thread is compounded by the compiler's reordering of code. For example,
the compiler might decide that it is more efficient to move a write operation
later in the program; as long as this code motion does not change the program's
semantics, it is free to do so. If a compiler defers an operation, another
thread will not see it until it is performed; this mirrors the effect of caching.

        Class Reordering {
          int x = 0, y = 0;
          public void writer() {
            x = 1;
            y = 2;
          }

          public void reader() {
            int r1 = y;
            int r2 = x;
          }
        }

    If code is executed in two threads concurrently, and the read of y sees the
    value 2. Because this write came after the write to x, the programmer might
    assume that the read of x must see the value 1. However, the writes may have
    been reordered. If this takes place, then the write to y could happen, the
    reads of both variables could follow, and then the write to x could take place.
    The result would be that r1 has the value 2, but r2 has the value 0.

    + There are a number of cases in which accesses to program variables
    (object instance fields, class static fields, and array elements) may appear
    to execute in a different order than was specified by the program.
        - The __compiler__ is free to take liberties with the ordering of instructions
        in the name of optimization.
        - __Processors__ may execute instructions out of order under certain circumstances.
        - Data may be moved between registers, processor caches, and main memory in
          different order than specified by the program.

    If a thread writes to field `a` and then to field `b`, and the value of
    `b` __does not depend on__ the value of `a`, then the compiler is free to
    reorder these operations, and the cache is free to flush `b` to main memory
    before `a`. There are a number of potential sources of reordering, such
    as the compiler, the JIT, and the cache.

    The compiler, runtime, and hardware are supposed to conspire to create
    the illusion of _as-if-serial_ semantics, which means that in a
    __single-threaded__ program, the program should not be able to observe the
    effects of reorderings. However, reorderings can come into play in
    _incorrectly synchronized multithreaded_ programs, where one thread is able
    to observe the effects of other threads, and may be able to detect that
    variable accesses become visible to other threads in a different order
    than executed or specified in the program.

    Most of the time, one thread doesn't care what the other is doing.
    But when it does, that's what synchronization is for.

* __Happened-before__
    + happened-before relation strict partial orders, denoted by `-->`
        - __transitivity:__ `for all a,b,c, if a --> b and b --> c then a --> c`
        - __irreflexivity:__ `for all a, a -/-> a`
        - __antisymmetry:__ `for all a,b, if a --> b then b -/-> a`

      In terms of JMM it is defined as follows-
        - Each action in a thread happens before every action in __that thread__
          that comes later in the program's order.
        - An unlock on a monitor happens before every subsequent lock on
          __that same__ monitor.
        - A write to a volatile field happens before every subsequent read of
          __that same__ volatile.
        - A call to `start()` on a thread happens before any actions in the
          started thread.
        - All actions in a thread happen before any other thread successfully
          returns from a `join()` on that thread.

    This means that any memory operations which were visible to a thread before
    exiting a synchronized block are visible to any thread after it enters a
    synchronized block protected by the same monitor, since all the memory
    operations happen before the release, and the release happens before the acquire.

    Following is no-op and compiler might remove it.

            synchronized (new Object()) {}
