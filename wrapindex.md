wrap index for circular/ring buffer
-----------------------------------

      void wrapIndex(){
        int size=2<<3; // make sure its always power of 2
        int mask = size-1;

        for(int i=0; i < (2*size); i++){
          int wrapped = i & mask;
          System.out.printf("%s & %s = %s %n",
            Integer.toBinaryString(i),
            Integer.toBinaryString(mask),
            Integer.toBinaryString(wrapped));
        }
      }

Prints

      0 & 1111 = 0
      1 & 1111 = 1
      10 & 1111 = 10
      11 & 1111 = 11
      100 & 1111 = 100
      101 & 1111 = 101
      110 & 1111 = 110
      111 & 1111 = 111
      1000 & 1111 = 1000
      1001 & 1111 = 1001
      1010 & 1111 = 1010
      1011 & 1111 = 1011
      1100 & 1111 = 1100
      1101 & 1111 = 1101
      1110 & 1111 = 1110
      1111 & 1111 = 1111
      10000 & 1111 = 0
      10001 & 1111 = 1
      10010 & 1111 = 10
      10011 & 1111 = 11
      10100 & 1111 = 100
      10101 & 1111 = 101
      10110 & 1111 = 110
      10111 & 1111 = 111
      11000 & 1111 = 1000
      11001 & 1111 = 1001
      11010 & 1111 = 1010
      11011 & 1111 = 1011
      11100 & 1111 = 1100
      11101 & 1111 = 1101
      11110 & 1111 = 1110
      11111 & 1111 = 1111

