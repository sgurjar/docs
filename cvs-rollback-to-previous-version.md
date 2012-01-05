Rollback to previous version of a file in cvs
=============================================

we have a file `a/b/c/x.txt` in cvs, which has current version 1.4
and we want to rollback to previos version 1.3.

1. `cd a/b/c`

2. make sure we have *Up-to-date* `x.txt` and current version is 1.3

          cvs status x.txt

3. we are chking out 1.2 version of `x.txt` in temp dir relative to `/a/b/c`
    (*absolute dir doesnt work*)

          cvs co -r1.2 -d temp a/b/c/x.txt


4. now we have 1.2 version of `x.txt` in our working dir

          mv temp/x.txt .

5. we can do `cvs diff` to make sure we have all the correct changes.

          cvs diff -wub x.txt

6. no differences should be found if we have correct version.

          cvs diff -wub -r1.2 x.txt

7. now we will commit `x.txt` on top of `x.txt` version 1.3

          cvs ci -m "rolled back to 1.2" x.txt

8. again no differences should found (except *cvs keywords* if you have in source file)

          cvs diff -r1.2 x.txt


