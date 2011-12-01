title=erasure not reified
tags=java,generics,erasure,reified

###erasure not reified

    1   public class T {
    2       public static void main(String[] args) throws Exception {
    3           A<String,B> a = new A<String,B>();
    4           B b = a.get("hello");
    5       }
    6
    7       static class B {}
    8
    9       static class A<K,V> {
    10          V get(K k) {
    11              Object obj = get_object_for(k);
    12              V v = (V)obj;
    13              return v;
    14          }
    15          Object get_object_for(K k) {
    16              return flipcoin() ? new Object() : new B();
    17          }
    18
    19          boolean flipcoin() {
    20              return (Math.random()*10)%2 < 1;
    21          }
    22      }
    23  }

This will fail at line number 4 whenever `flipcoin` returns true, (and one would
hope it to fail at line number 12 so at least we can catch `ClassCastException`
and handle it), what if I want to check in `A.get` if object retured from
`get_object_for` is an `instanceof` `B` or not and handle accordingly but
I can't do that due to generic type erasure might have worked if it were reified.