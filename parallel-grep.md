
    #!/bin/python

    from multiprocessing import Pool
    import sys, gzip, os.path

    def zgrep(gzfile):
      with gzip.open(gzfile) as gz:
        for line in gz:
          if 'a needle in a haystack' in line:
            print os.path.basename(gzfile), line,

    p = Pool() # cpu_count pools
    p.map(zgrep, sys.stdin.readlines(), 1)
    p.close()
    p.join()
