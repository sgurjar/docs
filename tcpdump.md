Title:tcpdump primer
Date:2011-11-22

    –n	name is not resolved and IP addresses are displayed
    –X	display both hex and ascii content in the packet
    –S	change display of sequence number to absolute rather then relative

It's also important to note that tcpdump only takes the first 96 bytes of data
from a packet by default. If you would like to look at more, add the `–s` number
option to the mix, where number is the number of bytes you want to capture.
I recommend using 0 (zero) for a snaplength, which gets everything.

Here's a short list of the options:

    –i any        : Listen on all interfaces just to see if you're seeing any traffic.
    –n            : Don't resolve hostnames.
    –nn           : Don't resolve hostnames or port names.
    –X            : Show the packet's contents in both hex and ASCII.
    –XX           : Same as –X, but also shows the ethernet header.
    –v, –vv, –vvv : Increase the amount of packet information you get back.
    –c            : Only get x number of packets and then stop.
    –s            : Define the size of the capture (use –s0 unless you are intentionally capturing less.)
    –S            : Print absolute sequence numbers.
    –e            : Get the ethernet header as well.
    –q            : Show less protocol information.
    –E            : Decrypt IPSEC traffic by providing an encryption key.
    –s            : Set the snaplength, i.e. the amount of data that is being captured in bytes
    –c            : Only capture x number of packets, e.g. 'tcpdump –c 3'

Basic Usage
-----------

* Basic communication // see the basics without many options

        $tcpdump –nS

* Basic communication (very verbose) // see a good amount of traffic, with verbosity and no name help

        $tcpdump –nnvvS

* A deeper look at the traffic // adds –X for payload but doesn't grab any more of the packet

        $tcpdump –nnvvXS

* Heavy packet viewing // the final "s" increases the snaplength, grabbing the whole packet

        $tcpdump –nnvvXSs 1514


Here's a capture of exactly two (–c2) ICMP packets (a ping and pong) using some
of the options described above. Notice how much we see about each packet.

    $ tcpdump –nnvXSs 0 –c2 icmp
    tcpdump: listening on eth0, link–type EN10MB (Ethernet), 23:11:10.370321 IP
    (tos 0x20, ttl  48, id 34859, offset 0, flags [none], length: 84)
    69.254.213.43 > 72.21.34.42: icmp 64: echo request seq 0

            0x0000:  4520 0054 882b 0000 3001 7cf5 45fe d52b  E..T.+..0.|.E..+
            0x0010:  4815 222a 0800 3530 272a 0000 25ff d744  H."*..50'*..%..D
            0x0020:  ae5e 0500 0809 0a0b 0c0d 0e0f 1011 1213  .^..............
            0x0030:  1415 1617 1819 1a1b 1c1d 1e1f 2021 2223  .............!"#
            0x0040:  2425 2627 2829 2a2b 2c2d 2e2f 3031 3233  $%&'()*+,–./0123
            0x0050:  3435 3637                                4567
    23:11:10.370344 IP (tos 0x20, ttl  64, id 35612, offset 0, flags [none],
    length: 84) 72.21.34.42 > 69.254.213.43: icmp 64: echo reply seq 0
            0x0000:  4520 0054 8b1c 0000 4001 6a04 4815 222a  E..T....@.j.H."*
            0x0010:  45fe d52b 0000 3d30 272a 0000 25ff d744  E..+..=0'*..%..D
            0x0020:  ae5e 0500 0809 0a0b 0c0d 0e0f 1011 1213  .^..............
            0x0030:  1415 1617 1819 1a1b 1c1d 1e1f 2021 2223  .............!"#
            0x0040:  2425 2627 2829 2a2b 2c2d 2e2f 3031 3233  $%&'()*+,–./0123
            0x0050:  3435 3637                                4567
    2 packets captured
    2 packets received by filter
    0 packets dropped by kernel
    $

Common Syntax
-------------

Three main types of expression: `type`, `dir`, and `proto`.

`type` options are `host`, `net`, and `port`. Direction is indicated by `dir`,
and there you can have `src`, `dst`, `src` or `dst`, and `src` and `dst`.
Here are a few examples:

* host // look for traffic based on IP address (also works with hostname if you're not using –n)

        $tcpdump host 1.2.3.4

* src, dst // find traffic from only a source or destination (eliminates one side of a host conversation)

        $tcpdump src 2.3.4.5
        $tcpdump dst 3.4.5.6

* net // capture an entire network using CIDR notation

        $tcpdump net 1.2.3.0/24

* proto // works for tcp, udp, and icmp. Note that you don't have to type proto

        $tcpdump icmp

* port // see only traffic to or from a certain port

        $tcpdump port 3389

* src, dst port // filter based on the source or destination port

        $tcpdump src port 1025
        $tcpdump dst port 389

* src/dst, port, protocol // combine all three

        $tcpdump src port 1025 and tcp
        $tcpdump udp and src port 53

You also have the option to filter by a range of ports instead of declaring them
individually, and to only see packets that are above or below a certain size.

* Port Ranges // see traffic to any port in a range

        $tcpdump portrange 21–23

* Packet Size Filter // only see packets below or above a certain size (in bytes)

        $tcpdump less 32
        $tcpdump greater 128

* You can use the symbols for less than, greater than, and less than or equal/greater
  than or equal signs as well.

        // filtering for size using symbols
        $tcpdump > 32
        $tcpdump <= 128

Writing to a File
-----------------

`tcpdump` allows you to send what you're capturing to a file for later use using
the `–w` option, and then to read it back using the `–r` option. This is an
excellent way to capture raw traffic and then run it through various tools later.
The traffic captured in this way is stored in tcpdump format, which is pretty
much universal in the network analysis space. This means it can be read in by
all sorts of tools, including Wireshark, Snort, etc.

* Capture all Port 80 Traffic to a File

        $tcpdump –s 1514 port 80 –w capture_file

* Read Captured Traffic back into tcpdump
        $tcpdump –r capture_file

Expressions
-----------

Expressions are nice, but the real magic of tcpdump comes from the ability to 
combine them in creative ways in order to isolate exactly what you're looking for. 
There are three ways to do combinations:

* AND
    
    and or &&

* OR

    or or ||

* EXCEPT
    
    not or !

More Examples
-------------

        # TCP traffic from 10.5.2.3 destined for port 3389
        tcpdump –nnvvS and src 10.5.2.3 and dst port 3389

        # Traffic originating from the 192.168 network headed for the 10 or 172.16 networks
        tcpdump –nvX src net 192.168.0.0/16 and dst net 10.0.0.0/8 or 172.16.0.0/16

        # Non–ICMP traffic destined for 192.168.0.2 from the 172.16 network
        tcpdump –nvvXSs 1514 dst 192.168.0.2 and src net and not icmp

        # Traffic originating from Mars or Pluto that isn't to the SSH port
        tcpdump –vv src mars and not dst port 22

        # Show me all URGENT (URG) packets
        tcpdump 'tcp[13] & 32!=0'

        # Show me all ACKNOWLEDGE (ACK) packets
        tcpdump 'tcp[13] & 16!=0'

        # Show me all PUSH (PSH) packets
        tcpdump 'tcp[13] & 8!=0'

        # Show me all RESET (RST) packets
        tcpdump 'tcp[13] & 4!=0'

        # Show me all SYNCHRONIZE (SYN) packets
        tcpdump 'tcp[13] & 2!=0'

        # Show me all FINISH (FIN) packets
        tcpdump 'tcp[13] & 1!=0'

        # Show me all SYNCHRONIZE/ACKNOWLEDGE (SYNACK) packets
        tcpdump 'tcp[13] & =18'

        # Capture TCP Flags Using the tcpflags Option
        tcpdump 'tcp[tcpflags] & & tcp–syn != 0'

        # IPv6 traffic
        tcpdump ip6

        #Packets with both the RST and SYN flags set (why?)
        tcpdump 'tcp[13] = 6'

        #Traffic with the 'Evil Bit' Set
        tcpdump 'ip[6] & 128 != 0'

###Grouping

Keep in mind that when you're building complex queries you might have to group 
your options using single quotes. Single quotes are used in order to tell `tcpdump`
to ignore certain special characters –– in this case the "( )" brackets. 
This same technique can be used to group using other expressions such as 
`host`, `port`, `net`, etc. Take a look at the command below:

        # Traffic that's from 10.0.2.4 AND destined for ports 3389 or 22 (INCORRECT)
        tcpdump src 10.0.2.4 and (dst port 3389 or 22)
    
        # Traffic that's from 10.0.2.4 AND destined for ports 3389 or 22 (CORRECT)
        tcpdump 'src 10.0.2.4 and (dst port 3389 or 22)'

--------------------------------------------------------------------------------
[A tcpdump Tutorial and Primer](http://danielmiessler.com/study/tcpdump/)
