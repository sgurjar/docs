Three-Way Handshake
-------------------
1.  server get prepared to accept an incoming connection (_passive open_) by
    calling socket, bind, and listen.

2.  client opens connection (_active open_) by calling connect. This causes
    the client TCP to send a "synchronize" (__SYN__) segment, which tells the
    server the client's initial sequence number for the data that the
    client will send on the connection. Normally, there is no data sent
    with the SYN; it just contains an IP header, a TCP header, and
    possible TCP options.

3.  server must acknowledge (__ACK__) the client's SYN and the server must also
    send its own SYN containing the initial sequence number for the data that
    the server will send on the connection. The server sends its SYN and
    the ACK of the client's SYN in a single segment.

4.  The client must acknowledge the server's SYN.

The minimum number of packets required for this exchange is three; hence,
this is called TCP's __three-way handshake__.

            TCP A                                              TCP B

        1.  CLOSED                                                LISTEN
        2.  SYN-SENT    --> <SEQ=100><CTL=SYN>                --> SYN-RECEIVED
        3.  ESTABLISHED <-- <SEQ=300><ACK=101><CTL=SYN,ACK>   <-- SYN-RECEIVED
        4.  ESTABLISHED --> <SEQ=101><ACK=301><CTL=ACK>       --> ESTABLISHED
        5.  ESTABLISHED --> <SEQ=101><ACK=301><CTL=ACK><DATA> --> ESTABLISHED

              Basic 3-Way Handshake for Connection Synchronization

TCP Connection Termination
--------------------------
1.  One application (client or server) calls close first, and we say that this
    end performs the _active close_. This end's TCP sends a __FIN__ segment,
    which means it is finished sending data.

2.  The other end that receives the FIN performs the _passive close_. The
    received FIN is acknowledged by TCP. The receipt of the FIN is also passed
    to the application as an end-of-file (after any data that may have already
    been queued for the application to receive), since the receipt of the FIN
    means the application will not receive any additional data on the connection.

3.  Sometime later, the application that received the end-of-file will close
    its socket. This causes its TCP to send a __FIN__.

4.  The TCP on the system that receives this final FIN (the end that did the
    active close) acknowledges the FIN.


          TCP A                                                TCP B

        1. ESTABLISHED                                          ESTABLISHED
        2. (Close)
           FIN-WAIT-1  --> <SEQ=100><ACK=300><CTL=FIN,ACK>  --> CLOSE-WAIT
        3. FIN-WAIT-2  <-- <SEQ=300><ACK=101><CTL=ACK>      <-- CLOSE-WAIT
                                                                (Close)
        4. TIME-WAIT   <-- <SEQ=300><ACK=101><CTL=FIN,ACK>  <-- LAST-ACK
        5. TIME-WAIT   --> <SEQ=101><ACK=301><CTL=ACK>      --> CLOSED
        6. (2 MSL)
           CLOSED
                        Normal Close Sequence

<pre>
________________________________________________________________________________
    CLIENT                                                  SERVER
-+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
                       |                                  | socket, bind, listen
                       |                                  | LISTEN (passive open)
                       |                                  | accept (blocks)
socket                 |                                  |
connect (blocks)       |                                  |
(active open) SYN_SENT |>>>>>>>>>>>>> SYN J, MSS=536      |
                       |             >>>>>>>>>>>>>>>>>>>>>| SYN_RCVD
                       | SYN K, ACK J+1, MSS=1460<<<<<<<<<|
ESTABLISHED            |<<<<<<<<<<<<<<<<<<<<              |
connect returns        |>>>>>>>>>>>>>>>       ACK K+1     |
                       |               >>>>>>>>>>>>>>>>>>>| ESTABLISHED
                       |                                  | accept return
                       |                                  | read (blocks)
                       |                                  |
write                  |>>>>>>>>>>>>>>>  data (request)   |
read (blocks)          |               >>>>>>>>>>>>>>>>>>>| read returns
                       |                                  |
                       |                                  |
                       | date (reply), ACK (request)<<<<<<| write
read returns           |<<<<<<<<<<<<<<<<<<<               | read (blocks)
                       |>>>>>>>>>>>>>>>>>>> ACK reply     |
                       |                   >>>>>>>>>>>>>>>|
close                  |                                  |
(active close)         |>>>>>>>>>>>>>>>>>>>               |
FIN_WAIT_1             |                  > FIN M         |
                       |                  >>>>>>>>>>>>>>>>| CLOSE_WAIT (passive close)
                       |                 <<<<<<<<<<<<<<<<<| read returns 0 (eof)
                       | ACK M+1         <<               |
FIN_WAIT_2             |<<<<<<<<<<<<<<<<<                 |
                       |                                  | close
                       | FIN N           <<<<<<<<<<<<<<<<<| LAST_ACK
TIME_WAIT              |<<<<<<<<<<<<<<<<<<    ACK N+1     |
                       |>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>| CLOSED
                       |                                  |
_________________________________________________________________________________
</pre>


CLOSE_WAIT
CLOSED
ESTABLISHED
FIN_WAIT_1
FIN_WAIT_2
LAST_ACK
LISTEN
SYN_RECEIVED
SYN_SEND
TIMED_WAIT