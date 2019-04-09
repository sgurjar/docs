# Cassandra recommended production settings
https://docs.datastax.com/en/dse/5.1/dse-dev/datastax_enterprise/config/configRecommendedSettings.html

## Use the latest Java Virtual Machine
Use the latest 64-bit version of Oracle Java Platform, Standard Edition 8 (JDK) or OpenJDK 8.

## TCP settings

    net.ipv4.tcp_keepalive_time=60
    net.ipv4.tcp_keepalive_probes=3
    net.ipv4.tcp_keepalive_intvl=10
    net.core.rmem_max=16777216
    net.core.wmem_max=16777216
    net.core.rmem_default=16777216
    net.core.wmem_default=16777216
    net.core.optmem_max=40960
    net.ipv4.tcp_rmem=4096 87380 16777216
    net.ipv4.tcp_wmem=4096 65536 16777216

## Increase max memory map areas a process can have
https://www.kernel.org/doc/Documentation/sysctl/vm.txt

    vm.max_map_count = 1048575

## Disable Swap

    vm.swappiness=1

## Disable CPU frequency scaling

    for CPUFREQ in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    do
        [ -f $CPUFREQ ] || continue
        echo -n performance > $CPUFREQ
    done

## Optimize SSDs

  1. Ensure that the SysFS rotational flag is set to false (zero).

          # rotational must be 0 for ssd
          cat /sys/block/$ssd_dev/queue/rotational

  2. Set the IO scheduler to either deadline or noop:

          # scheduler is deadline or `noop`. values listed within [] is set.
          cat /sys/block/$ssd_dev/queue/scheduler

  3. Set the readahead value for the block device to 8 KB.

          # read_ahead_kb, recomended ia 8kb
          cat /sys/class/block/$ssd_dev/queue/read_ahead_k

## Disable zone_reclaim_mode on NUMA systems

    # followi ng must be 0
    cat /proc/sys/vm/zone_reclaim_mode

## Set user resource limits

    # /etc/security/limits.conf
    <cassandra_user> - memlock unlimited
    <cassandra_user> - nofile 100000
    <cassandra_user> - nproc 32768
    <cassandra_user> - as unlimited

## Check the Java Hugepages setting

    # if this says 'never' then its disabled
    cat /sys/kernel/mm/transparent_hugepage/enabled

    # cs* docs says, update the flag to 'never'
    # since we /sys/kernel/mm/transparent_hugepage/enabled never we are good
    cat /sys/kernel/mm/transparent_hugepage/defrag

## GC
  - Use G1 for jdk 8
  - assign 1/4th of RAM to JVM.
