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

```
#!/bin/bash

# PerfDisableSharedMem so that jrunscript wont find itself

/usr/java/jdk1.8.0_20/bin/jrunscript -J-XX:+PerfDisableSharedMem -cp /usr/java/jdk1.8.0_20/lib/jconsole.jar -e '
var lvms = Packages.sun.tools.jconsole.LocalVirtualMachine.getAllVirtualMachines()
for each (var pid in lvms.keySet()) {
  print(pid + "\t" + lvms.get(pid) + "\t" + lvms.get(pid).connectorAddress());
}'
```
