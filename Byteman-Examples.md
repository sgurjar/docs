## Byteman
<http://byteman.jboss.org/>

### Run
~~~~
byteman="-javaagent:${BASE_DIR}/byteman.jar=boot:${BASE_DIR}/byteman.jar,script:${BASE_DIR}/kfk.btm"

$JAVA_DIR/java \
 -Xmn96G -Xmx128G \
 -D${PROG_NAME} \
 -cp "${BASE_DIR}/lib/*" \
 ${byteman} \
 ${MAIN_CLASS} \
 1> ${LOGS_DIR}/out_${TIMESTAMP}.log \
 2> ${LOGS_DIR}/err_${TIMESTAMP}.log
~~~~

### Scripts
#### `kfk.btm`

~~~~
RULE Selectable.connect
INTERFACE ^org.apache.kafka.common.network.Selectable
METHOD connect(String, InetSocketAddress, int, int)
AT EXIT
IF TRUE
DO traceStack("### " +
  java.time.LocalDateTime.now() +
  " " + $METHOD +
  " [" + Thread.currentThread().getName() + "]" +
  " " + System.identityHashCode($0) +
  " id=" + $1 +
  " address=" + $2 +
  " sendBufferSize=" + $3 +
  " receiveBufferSize=" + $4 +
  "\n",
  10
  )
ENDRULE

RULE Selectable.close
INTERFACE ^org.apache.kafka.common.network.Selectable
METHOD close()
AT EXIT
IF TRUE
DO traceStack("### " +
  java.time.LocalDateTime.now() +
  " " + $METHOD +
  " [" + Thread.currentThread().getName() + "]" +
  " " + System.identityHashCode($0) +
  "\n",
  10
  )
ENDRULE

RULE Selectable.close id
INTERFACE ^org.apache.kafka.common.network.Selectable
METHOD close(String)
AT EXIT
IF TRUE
DO traceStack("### " +
  java.time.LocalDateTime.now() +
  " " + $METHOD +
  " [" + Thread.currentThread().getName() + "]" +
  " " + System.identityHashCode($0) +
  " id=" + $1 +
  "\n",
  10
  )
ENDRULE
~~~~

#### `socket.btm`

~~~~
RULE Socket
CLASS ^java.net.Socket
METHOD <init>()
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " "+ System.identityHashCode($0) + " ", 15)
ENDRULE


RULE Socket Proxy
CLASS ^java.net.Socket
METHOD <init>(Proxy)
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " "+ System.identityHashCode($0) + " ", 15)
ENDRULE


RULE Socket SocketImpl
CLASS ^java.net.Socket
METHOD <init>(SocketImpl)
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " "+ System.identityHashCode($0) + " ", 15)
ENDRULE

RULE Socket host port
CLASS ^java.net.Socket
METHOD <init>(String, int)
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " "+ System.identityHashCode($0) + " host=" + $1 + " port=" + $2 + " ", 15)
ENDRULE

RULE Socket addr port
CLASS ^java.net.Socket
METHOD <init>(InetAddress, int)
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " " + System.identityHashCode($0) + " addr="+$1 + " port="+$2 + " ", 15)
ENDRULE


RULE Socket host port localAddr localPort
CLASS ^java.net.Socket
METHOD <init>(String, int, InetAddress, int)
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " "+ System.identityHashCode($0) + " host="+$1 + " port="+$2 + " localaddr="+$3 + " localport="+$4 + " ", 15)
ENDRULE

RULE Socket address port localAddr localPort
CLASS ^java.net.Socket
METHOD <init>(InetAddress, int, InetAddress, int)
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " "+ System.identityHashCode($0) + " addr="+$1 + " port=" + $2 + " localaddr="+$3 + " localport=" + $4 + " "  , 15)
ENDRULE

RULE Socket host port stream
CLASS ^java.net.Socket
METHOD <init>(String, int, boolean)
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " "+ System.identityHashCode($0) + " host=" + $1 + " port=" + $2 + " stream="+$3 + " ", 15)
ENDRULE

RULE Socket addr port stream
CLASS ^java.net.Socket
METHOD <init>(InetAddress, int, boolean)
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " "+ System.identityHashCode($0) + " addr=" + $1 + " port=" + $2 + " stream=" + $3 + " ", 15)
ENDRULE

RULE Socket connect
CLASS ^java.net.Socket
METHOD connect(SocketAddress)
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " "+ System.identityHashCode($0) + " addr="+$1 + " ", 15)
ENDRULE

RULE Socket connect timeout
CLASS ^java.net.Socket
METHOD connect(SocketAddress, int)
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " "+ System.identityHashCode($0) + " addr="+$1 + " timeout="+$2 + " " , 15)
ENDRULE

RULE Socket bind InetAddress int
CLASS ^java.net.Socket
METHOD bind(InetAddress, int)
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " "+ System.identityHashCode($0) + " host="+$1 + " port="+$2 + " ", 15)
ENDRULE


RULE Socket close
CLASS ^java.net.Socket
METHOD close()
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " "+ System.identityHashCode($0) + " " + $0 + " ", 15)
ENDRULE

#####################
# SocketImpl
#####################

RULE SocketImpl connect
CLASS ^java.net.SocketImpl
METHOD connect(String, int)
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " "+ System.identityHashCode($0) + " host="+$1 + " port="+$2 + " ", 15)
ENDRULE

RULE SocketImpl connect InetAddress int
CLASS ^java.net.SocketImpl
METHOD connect(InetAddress, int)
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " "+ System.identityHashCode($0) + " host="+$1 + " port="$2 + " ", 15)
ENDRULE

RULE SocketImpl connect SocketAddress int
CLASS ^java.net.SocketImpl
METHOD connect(SocketAddress, int)
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " "+ System.identityHashCode($0) + " host="+$1 + " port="+$2 + " ", 15)
ENDRULE

RULE SocketImpl bind InetAddress int
CLASS ^java.net.SocketImpl
METHOD bind(InetAddress, int)
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " "+ System.identityHashCode($0) + " host="+$1 + " port="+$2 + " ", 15)
ENDRULE

RULE SocketImpl close
CLASS ^java.net.SocketImpl
METHOD close()
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " "+ System.identityHashCode($0) + " " + $0 + " ", 15)
ENDRULE

##############
# java.nio.channels.SocketChannel
##############
RULE SocketChannel connect
CLASS ^java.nio.channels.SocketChannel
METHOD connect(SocketAddress)
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " "+ System.identityHashCode($0) + " " + $0 + " remote="+$1 + " ", 15)
ENDRULE

RULE SocketChannel close
CLASS ^java.nio.channels.SocketChannel
METHOD close()
AT EXIT
IF TRUE
DO traceStack("*** " + java.time.LocalDateTime.now() + "[" + $METHOD + "] " + Thread.currentThread() + " "+ System.identityHashCode($0) + " " + $0 + " ", 15)
ENDRULE
~~~~
