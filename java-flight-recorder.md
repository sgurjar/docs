# Java Flight Recorder

* The following example uses java command-line options to run MyApp and
  immediately start a 60-second recording. The recording will be saved to
  a file named myrecording.jfr:

```
java -XX:+UnlockCommercialFeatures \
     -XX:+FlightRecorder \
     -XX:StartFlightRecording=duration=60s,filename=myrecording.jfr \
     MyApp
```

* Unlock commercial features and enable Java Flight Recorder
  + Must be done before creating flight recording.

```
-XX:+UnlockCommercialFeatures
-XX:+FlightRecorder
```

## Using `jcmd`

* To start a 60-second recording on the running Java process with the
  identifier 5368 and save it to myrecording.jfr in the current directory,
  use the following:

```
jcmd 5368 JFR.start duration=60s filename=myrecording.jfr
```

### Unlocks commercial features and enables Java Flight Recorder dynamically at runtime.

```
$java -jar MyApp.jar
$jcmd 40019 VM.command_line
40019:
VM Arguments:
java_command: MyApp.jar
java_class_path (initial): MyApp.jar
Launcher Type: SUN_STANDARD

$jcmd 40019 VM.check_commercial_features
40019:
Commercial Features are locked.

$jcmd 40019 JFR.check
40019:
Java Flight Recorder not enabled.

Use VM.unlock_commercial_features to enable.

$jcmd 40019 VM.unlock_commercial_features
40019:
Commercial Features now unlocked.

$jcmd 40019 VM.check_commercial_features
40019:
Commercial Features are unlocked.
Status of individual features:
  Java Flight Recorder has not been used.
Resource Management is disabled.

$jcmd 40019 JFR.check
40019:

No available recordings.

Use JFR.start to start a recording.

$jcmd 40019 JFR.start name=my_recording filename=myrecording.jfr dumponexit=true
40019:
Started recording 1. No limit (duration/maxsize/maxage) in use.

Use JFR.dump name=my_recording to copy recording data to file.

$jcmd 40019 VM.check_commercial_features
40019:
Commercial Features are unlocked.
Status of individual features:
  Java Flight Recorder has been used.
  Resource Management is disabled.

$jcmd 40019 JFR.check
40019:
Recording: recording=1 name="my_recording" filename="myrecording.jfr" compress=false (running)
```

### Using `-XX:+UnlockCommercialFeatures` and `-XX:+FlightRecorder`

```
$java -XX:+UnlockCommercialFeatures -XX:+FlightRecorder -jar MyApp.jar

$jcmd 37152 VM.command_line
37152:
VM Arguments:
jvm_args: -XX:+UnlockCommercialFeatures -XX:+FlightRecorder
java_command: MyApp.jar
java_class_path (initial): MyApp.jar
Launcher Type: SUN_STANDARD
$jcmd 37152 VM.check_commercial_features
37152:
Commercial Features are unlocked.
Status of individual features:
  Java Flight Recorder has not been used.
  Resource Management is disabled.

$jcmd 37152 JFR.check
37152:
No available recordings.

Use JFR.start to start a recording.

$jcmd 37152 JFR.start name=my_recording filename=myrecording.jfr dumponexit=true
37152:
Started recording 1. No limit (duration/maxsize/maxage) in use.

Use JFR.dump name=my_recording to copy recording data to file.


$jcmd 37152 JFR.check
37152:
Recording: recording=1 name="my_recording" filename="myrecording.jfr" compress=false (running)

$jcmd 37152 VM.check_commercial_features
37152:
Commercial Features are unlocked.
Status of individual features:
  Java Flight Recorder has been used.
  Resource Management is disabled.
```

### Using `-XX:+UnlockCommercialFeatures` with a JFR Dynamic Start

```
$java -XX:+UnlockCommercialFeatures -jar MyApp.jar

$jcmd 39970 VM.command_line
39970:
VM Arguments:
jvm_args: -XX:+UnlockCommercialFeatures
java_command: MyApp.jar
java_class_path (initial): MyApp.jar
Launcher Type: SUN_STANDARD

$jcmd 39970 VM.check_commercial_features
39970:
Commercial Features are unlocked.
Status of individual features:
  Java Flight Recorder has not been used.
  Resource Management is disabled.

$jcmd 39970 JFR.check
39970:
No available recordings.

Use JFR.start to start a recording.

$jcmd 39970 VM.check_commercial_features
39970:
Commercial Features are unlocked.
Status of individual features:
  Java Flight Recorder has not been used.
  Resource Management is disabled.

$jcmd 39970 JFR.start name=my_recording filename=myrecording.jfr dumponexit=true

39970:

Started recording 1. No limit (duration/maxsize/maxage) in use.

Use JFR.dump name=my_recording to copy recording data to file.

$jcmd 39970 VM.check_commercial_features

39970:

Commercial Features are unlocked.
Status of individual features:
  Java Flight Recorder has been used.
  Resource Management is disabled.

$jcmd 39970 JFR.check
39970:
Recording: recording=1 name="my_recording" filename="myrecording.jfr" compress=false (running)
```

### Locking Commercial Features with `-XX:-UnlockCommercialFeatures`

```
$ java -XX:-UnlockCommercialFeatures -jar MyApp.jar

$jcmd 40110 VM.command_line
40110:
VM Arguments:
jvm_args: -XX:-UnlockCommercialFeatures
java_command: MyApp.jar
java_class_path (initial): MyApp.jar
Launcher Type: SUN_STANDARD

$jcmd 40110 VM.check_commercial_features
40110:
Commercial Features are locked.

$jcmd 40110 VM.unlock_commercial_features
40110:
Commercial Features now unlocked.

$jcmd 40110 VM.check_commercial_features
40110:
Commercial Features are unlocked.
Status of individual features:
  Java Flight Recorder has not been used.
  Resource Management is disabled.

$jcmd 40110 JFR.start name=my_recording filename=myrecording.jfr dumponexit=true
40110:
Started recording 1. No limit (duration/maxsize/maxage) in use.

Use JFR.dump name=my_recording to copy recording data to file.

$jcmd 40110 JFR.check
40110:
Recording: recording=1 name="my_recording" filename="myrecording.jfr" compress=false (running)

$jcmd 40110 VM.check_commercial_features
40110:
Commercial Features are unlocked.
Status of individual features:
  Java Flight Recorder has been used.
  Resource Management is disabled.
```

### Disabling JFR with `-XX:-FlightRecorder`

```
$java -XX:+UnlockCommercialFeatures -XX:-FlightRecorder -jar MyApp.jar
$jcmd 39589 VM.command_line
39589:
VM Arguments:
jvm_args: -XX:+UnlockCommercialFeatures -XX:-FlightRecorder 
java_command: MyApp.jar
java_class_path (initial): MyApp.jar
Launcher Type: SUN_STANDARD

$jcmd 39589 VM.check_commercial_features

39589:
Commercial Features are unlocked.
Status of individual features:
  Java Flight Recorder is disabled.
  Resource Management is disabled.

$jcmd 39589 JFR.check
39589:
Java Flight Recorder is disabled.

$jcmd 39589 JFR.stop
39589:
Java Flight Recorder is disabled.

$jcmd 39589 VM.unlock_commercial_features
39589:
Commercial Features already unlocked.

$jcmd 39589 JFR.start name=my_recording filename=myrecording.jfr dumponexit=true
39589:
Java Flight Recorder is disabled.
```

## Configuring Recordings

```
# k m g suffix, for bytes no suffix
maxsize=10M

# s (seconds) m (minutes) h (hours) d (days) suffix
maxage=10m

# If both a size limit and an age are specified, 
# the data is deleted when either limit is reached.
```

* `delay` before the recording is actually started

```
delay=10s

# s (seconds) m (minutes) h (hours) d (days) suffix
```

* `compress` recording data (no recommended, CPU resources required for compression can negatively impact performance)

```
compress=true
```

## Creating a Recording On Exit

```
-XX:FlightRecorderOptions=defaultrecording=true,dumponexit=true,dumponexitpath=path

# or

-XX:StartFlightRecording=name=test,filename=D:\test.jfr,dumponexit=true
```

----
1. [Running Java Flight Recorder](https://docs.oracle.com/javacomponents/jmc-5-5/jfr-runtime-guide/comline.htm#JFRRT184)
