% hadoop config notes
% 4/10/2014

hadoop config
==============

    wget http://mirrors.advancedhosters.com/apache/hadoop/common/hadoop-1.2.1/hadoop-1.2.1.tar.gz
    tar zxf hadoop-1.2.1.tar.gz
    cp -r  hadoop-1.2.1/conf/ conf-1.2.1/
    ln -s ./conf-1.2.1 ./conf

* `hadoop-env.sh` specifies environment variables that affect the JDK used
  by Hadoop, daemon JDK options, the pid file, and log file directories.

* `core-site.xml` specifies parameters relevant to all Hadoop daemons
  and clients.

* `hdfs-site.xml` specifies parameters used by the HDFS daemons and clients.

* `mapred-site.xml` specifies parameters used by the MapReduce daemons and clients.

* `log4j.properties`  self-ex

* `masters` (optional) A newline separated list of machines that run the
  secondary namenode, used only by the `start-*.sh` helper scripts.

* `slaves` (optional) A newline separated list of machine names that run
  the datanode/tasktracker pair of daemons, used only by the `start-*.sh`
  helper scripts.

* `fair-scheduler.xml` (optional) specify the resource pools and settings
  for the Fair Scheduler task scheduler plugin for MapReduce.

* `capacity-scheduler.xml` (optional) The name of the file used to specify
  the queues and settings for the Capacity Scheduler task scheduler plugin
  for MapReduce.

* `dfs.include` (optional, conventional name) A newline separated list of
  machine names that are permitted to connect to the namenode.

* `dfs.exclude` (optional, conventional name) A newline separated list of
  machine names that are not permitted to connect to the namenode.

* `hadoop-policy.xml` An XML file that defines which users and/or
  groups are permitted to invoke specific RPC functions when communicating
  with Hadoop.

* `mapred-queue-acls.xml` An XML file that defines which users and/or
  groups are permitted to submit jobs to which MapReduce job queues.

* `taskcontroller.cfg` A Java property-style file that defines values
  used by the setuid task-controller MapReduce helper program used when
  operating in secure mode.

Many of these files are loaded by Hadoop by way of Java's ClassLoader
resource loading mechanic. The Hadoop scripts ensure the conf directory
is always at the head of the classpath so files can easily be located
by the code.

Properties defined in `coresite.xml`, `hdfs-site.xml`, and
`mapred-site.xml` files override built in default values which are
contained within the main Hadoop jar file. When a MapReduce job is run,
the job configuration provided by the developer can, in turn, override
properties configured on the server. for example config look in
`share/hadoop/templates/conf`,

In situations where it is possible for a developer to override a property
but they should not be permitted to do so, an administrator can mark a
property as final to prevent it from happening.When a property is marked
final on the cluster but it's set by a job, the value set by the job is
ignored by the framework.

    <?xml version="1.0"?>
    <configuration>
      <!-- Set 'some.property.name' to the value 'some-value'.
      <property>
        <name>some.property.name</name>
        <value>some-value</value>
      </property>
      <!--
      Set 'foo.bar.baz' to the value '42' and prevent it from
      being overridden by marking it final.
      -->
      <property>
        <name>foo.bar.baz</name>
        <value>42</value>
        <final>true</final>
      </property>
      <!-- Additional property elements... -->
    </configuration>

* `conf/hadoop-env.sh`

        HADOOP_HOME
        JAVA_HOME
        HADOOP_HEAPSIZE
        HADOOP_OPTS
        HADOOP_LOG_DIR

if you catch yourself thinking about setting something like
`$HADOOP_CONF_DIR` or `$HADOOP_HOME`, it's probably worth taking a hard
look at how the software is deployed. The hadoop command will, provided
it's in your path, locate `$HADOOP_HOME` correctly in almost all cases.

In some cases, users may ask administrators to add jar files to
`$HADOOP_CLASSPATH` so they may be used in MapReduce jobs. Resist this at
all costs. Instead, gently encourage users to use Hadoop's Distributed
Cache feature to push job dependencies to the nodes of the cluster where
they are required when they submit the job.

After version 0.20.205 (and subsequently 1.0), the environment variable
`$HADOOP_HOME` was deprecated in favor of `$HADOOP_PREFIX`.

* `conf/log4j.properties`
  loggging config file

* HDFS

  + `fs.default.name` (`core-site.xml`)
    `hdfs://hostname:port` where `hostname` and `port` are the `machine`
    and `port` on which the __namenode__ daemon runs and listens.
    informs the namenode as to which IP and port it should bind.
    Datanodes heartbeat to this hostname and port as well.
    `FileSystem.get()` gain access to a specific implementation of a filesystem.
     hostnames, it is possible to instead reference machines by IP address.
       - Used by: NN, DN, SNN, JT, TT, clients.

  + `dfs.name.dir` (`hdfs-site.xml`)
    Specifies a comma separated list of local directories (with no spaces)
    in which the __namenode__ should store a copy of the HDFS filesystem
    metadata. Given the criticality of the metadata, administrators
    are strongly encouraged to specify two internal disks and a low
    latency, highly reliable, NFS mount. A complete copy of the metadata
    is stored in each directory; in other words, the namenode mirrors
    the data between directories. Default value of `dfs.name.dir` is
    `hadoop.tmp.dir/dfs/name` and, when coupled with hadoop.tmp.dir's default
    of `/tmp/hadoop-user.name`, lands the filesystem metadata squarely in
    a volatile directory, may clear on reboot.
      - Example value: `/data/1/dfs/nn,/data/2/dfs/nn,/data/3/dfs/nn`
      - Used by: NN

  + `dfs.data.dir` (`hdfs-site.xml`)
    Where datanodes should store HDFS block data. Also a comma separate
    list, rather than mirroring data to each directory specified, the
    datanode __round robins blocks between disks__ in an attempt to allocate
    blocks evenly across all drives. The datanode assumes each directory
    specifies a separate physical device in a JBOD group. JBOD, mean each
    disk individually addressable by the OS, and formatted and mounted as
    a separate mount point. Loss of a physical disk is not critical since
    replicas will exist on other machines in the cluster.
      - Example value: `/data/1/dfs/dn,/data/2/dfs/dn,/data/3/dfs/dn,/data/4/dfs/dn`
      - Used by: `DN`

  + `fs.checkpoint.dir` (`hdfs-site.xml`)
    Comma separated list of directories used by the __secondary namenode__
    in which to store filesystem metadata during a checkpoint operation. If
    multiple directories are provided, the secondary namenode mirrors the
    data in each directory the same way the namenode does. It is a valid
    copy of the data required to restore a completely failed namenode.
    It not a true backup because it's possible that the secondary namenode
    could fail, leaving us without a backup at all.
      - Example:  `/data/1/dfs/snn`
      - Used by:  `SNN`

  + `io.file.buffer.size` (`core-site.xml`)
    general purpose IO buffer size. should be set to a multiple of the
    system page size, defined in bytes, and is 4KB by default. 64KB is a
    good starting point.
      - Example value: 65536.
      - Used by: Clients, daemons.

  + `dfs.balance.bandwidthPerSec` (`hdfs-site.xml`)
    HDFS balancer utility looks for over or underutilized datanodes in
    the cluster and moves blocks between them in an effort to balance the
    distribution of blocks. If the balancing operation were not rate limited,
    it would easily monopolize the network leaving nothing for MapReduce jobs
    or data ingest. The `dfs.balance.bandwidthPerSec` parameter specifies how
    much bandwidth each datanode is allowed to used for balancing. The value
    is given in bytes.this parameter is used by each datanode to control
    bandwidth and is read by the daemon at startup time. This prevents the
    value from being specified by the administrator at the time the balancer
    is run.
      - Used by: DN

  + `dfs.block.size` (`hdfs-site.xml`)
    determines the default block size for all newly created files. It doesn't
    affect files that already exist in the filesystem and clients sometimes
    override it when they have special information about the files they'll
    create. `dfs.block.size` parameter value is expressed in bytes and is
    67108864 (64MB) by default. proper block size for a file depends on the
    data and how its processed, but for most use cases, 134217728 (128MB)
    is a more appropriate default. Hadoop MapReduce (specifically jobs
    that use input formats that subclass `FileInputFormat`) wind up with a
    map task for each block of the file(s) processed as part of the job.1
    This means the file block size can significantly impact the efficiency
    of a MapReduce job for better or worse.
      - Example value: 134217728
      - Used by: Clients.

  + `dfs.datanode.du.reserved` (`hdfs-site.xml`)
    When the datanode reports the available disk capacity to the namenode,
    it will report the sum of the unused capacity of all dfs.data.dir disks.
    Since `mapred.local.dir` usually shares the same available disk space,
    there needs to be a way to reserve disk space for MapReduce applications.
    The value of dfs.datanode.du.reserved specifies the amount of space,
    in bytes, to be reserved on each disk in dfs.data.dir. No disk space is
    reserved, by default, meaning HDFS is allowed to consume all available
    disk space on each data disk, at which point the node becomes read
    only. Instead, it is adviseable to reserve at least 10GB per disk for
    map task output by setting dfs.datanode.du.reserved to 10737418240. If
    the average MapReduce job produces a significant amount of intermediate
    output (again, this is map task output) or you have large disks (where
    each disk is greater than 2TB), increase the amount of reserved capacity
    accordingly.
      - Example value: 10737418240
      - Used by: DN

  + `dfs.namenode.handler.count` (`hdfs-site.xml`)
    namenode has a pool of worker threads that are responsible for processing
    RPC requests from clients as well as other cluster daemons. default of 10.
    A general guideline for setting dfs.namenode.handler.count is to make
    it the natural logarithm of the number of cluster nodes, times 20

~~~~python
          python -c 'import math ; print int(math.log(200) * 20)'
          105
~~~~

        - Example value: 105 based on a 200 node cluster.
        - Used by: NN.

  + `dfs.datanode.failed.volumes.tolerated` (`hdfs-site.xml`)
    number of disks that are permitted to die before failing the entire
    datanode.
      - Example value: 1.
      - Used by: DN.

  + `dfs.hosts` (`hdfs-site.xml`)
  list of hostnames of datanodes that are explicitly allowed to connect and
  join the cluster, in which case, all others are denied.
      - Example value: `/etc/hadoop/conf/dfs.hosts`
      - Used by: NN.

  + `dfs.host.exclude` (`hdfs-site.xml`)
    explicitly excluding machines from the cluster by specifying a file
    that contains a newline separate list of hostnames or IP addresses.
    also the method by which datanodes are gracefully decommissioned.
      - Example value: `/etc/hadoop/conf/dfs.hosts.exclude`
      - Used by: NN.

  + `fs.trash.interval` (`core-site.xml`)
    recycle bin of deleted files. When enabled, a file is moved to a
    special directory called `.Trash` in the user's HDFS home directory upon
    deletion rather than being removed immediately. The `fs.trash.interval`
    specifies the amount of time (in minutes) the file is retained in
    the .Trash directory prior to being permanently deleted from HDFS.
    explicitly empty the trash by running the `hadoop fs -expunge`

