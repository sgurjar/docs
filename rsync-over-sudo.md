```bash
dryrun=-n
rsync $dryrun \
 --exclude=/saved_caches \
 --exclude=/commitlog \
 --exclude=/hints \
 --exclude=/logs \
 --exclude=/data \
 --exclude=*.pyc \
 --exclude=/_my_key_ \
 -e 'ssh -q -i ./_my_key_' \
 --rsync-path="sudo -u cassandra rsync" \
 -rptgoD \
 --safe-links \
 --delete \
 -v \
 -c \
 ./ alice@my.remote.host:/usr/share/apache-cassandra-3.11.4/ 
 
# ./_my_key_ is ssh private key
```
