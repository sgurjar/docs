### Example of Nashorn script.
* <https://docs.oracle.com/javase/8/docs/technotes/guides/scripting/nashorn/shell.html>
* <https://docs.oracle.com/javase/8/docs/technotes/tools/unix/jjs.html>

### script to print diff between two properties files.

```javascript
#!/export/tools/java/bin/jjs

/////////////////////////////////////
// script to print diff between
// two properties files.
/////////////////////////////////////

function load_prop(filename) {
  var prop = new java.util.Properties();
  prop.load(new java.io.FileInputStream(filename));
  return prop;
}

function set_diff(s1, s2) {
  s1.removeAll(s2);
  return sorted(s1);
}

function set_intersection(s1, s2) {
  s1.retainAll(s2);
  return sorted(s1);
}

function sorted(s) {
  var a = new java.util.ArrayList(s);
  java.util.Collections.sort(a);
  return a;
}

function diff(p1, p2) {
  print("####in LHS not in RHS: ");
  for each (var k in set_diff(p1.stringPropertyNames(), p2.stringPropertyNames())) {
    print("\t" + k + "=" + p1.getProperty(k));
  }
  print("\n####in RHS not in LHS: ");
  for each (var k in set_diff(p2.stringPropertyNames(), p1.stringPropertyNames())) {
    print("\t" + k + "=" + p2.getProperty(k));
  }

  print("\n####in Both: (key ==> LHS - RHS)");
  for each (var key in set_intersection(p1.stringPropertyNames(), p2.stringPropertyNames())) {
    if(p1.getProperty(key).equals(p2.getProperty(key))) {
      print("\t= " + key + " ==> " + p1.getProperty(key) + " - " + p2.getProperty(key));
    } else {
      print("\t! " + key + " ==> " + p1.getProperty(key) + " - " + p2.getProperty(key));
    }
  }
}

if (arguments.length != 2) {
  print("usage: diff_props -- properties_file_lhs properties_file_rhs");
  print("example: ");
  print(" ./diff_props -- server.properties server.properties.original");
} else {
  diff(load_prop(arguments[0]), load_prop(arguments[1]));
}
```

### print JMX url for local JVMs

* `sun.tools.jconsole.LocalVirtualMachine` is in `jconsole.jar`
* To call static method we need to use `Packages.` syntax or `Java.type`. See https://stackoverflow.com/questions/28238139/how-can-i-access-a-static-method-only-class-via-scriptengine and https://docs.oracle.com/javase/8/docs/technotes/guides/scripting/nashorn/api.html
* I couldnt set classpath on shebang, so I use `jrunscript` with `-e` to pass inline script.

```javascript
#!/bin/bash

# PerfDisableSharedMem so that jrunscript wont find itself

/usr/java/jdk1.8.0_20/bin/jrunscript -J-XX:+PerfDisableSharedMem -cp /usr/java/jdk1.8.0_20/lib/jconsole.jar -e '
var lvms = Packages.sun.tools.jconsole.LocalVirtualMachine.getAllVirtualMachines();
for each (var pid in lvms.keySet()) {
  print(pid + "\t" + lvms.get(pid) + "\t" + lvms.get(pid).connectorAddress());
}'
```

## Call a Mbean method using PID of the local JVM.

```javascript
#!/bin/bash

# ===!!!!! type value of following variables !!!!!===

#java_dir=/your/path/here/java
#prog_name=TYPE_PGREP_STRING_HERE
#user=TYPE_USER
# =================================

pid=$(pgrep -u $user -f $prog_name)

if [[ ! $pid ]]; then
  echo "$prog_name is NOT running"
  exit 1
fi

# PerfDisableSharedMem so jrunscript wont find itsel

$java_dir/bin/jrunscript -J-XX:+PerfDisableSharedMem -J-Dmypid=$pid -cp $java_dir/lib/jconsole.jar -e '

// import packages
System              = Java.type("java.lang.System")
LocalVirtualMachine = Java.type("sun.tools.jconsole.LocalVirtualMachine")
JMXConnectorFactory = Java.type("javax.management.remote.JMXConnectorFactory")
Integer             = Java.type("java.lang.Integer")

var pid = System.getProperty("mypid")
var lvms = LocalVirtualMachine.getAllVirtualMachines()
if (pid == null) {
  print("No pid")
  exit(1)
} else {
  var myjvm = lvms.get(Integer.parseInt(pid))
  if (myjvm == null) {
    print("No JVM for pid " + pid)
    exit(1)
  } else {
    var url = myjvm.connectorAddress()
    var jmx = JMXConnectorFactory.connect(new javax.management.remote.JMXServiceURL(url))
    try {
      var mbeanserver = jmx.getMBeanServerConnection()
      var cmdline = mbeanserver.invoke(new javax.management.ObjectName("com.sun.management:type=DiagnosticCommand"),
                                       "vmCommandLine", // operationName
                                       null,            // params
                                       null)            // signature
      print(cmdline)
    }
    finally {
      jmx.close()
    }
  }
}
'
```
