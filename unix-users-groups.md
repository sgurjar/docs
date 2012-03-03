Title: UNIX permissions and chmod
Date: 2012-03-02
URL: http://www.perlfect.com/articles/chmod.shtml

Users
-----
UNIX identifies each user by a User ID (UID) and the username (or login) such
as 'nick' and 'www' is just an alias to the UID that makes humans more comfortable.

Groups
------
concept of groups serves the purpose of assigning sets of privileges for a
given resource and sharing them among many users that need to have them.

Ownership
---------
Every file in UNIX has an owner user and an owner group. For any file in the
system, user 'nick' may have one of the following ownership relations:

1. nick owns the file, i.e. the file's owner is 'nick'.
2. nick is a member of the group that owns the file, i.e. the file's owner group is 'perlfect'.
3. nick is neither the owner, nor belonging to the group that owns the file

Permissions
-----------
Every file on the system has associated with it a set of permissions.

* read it,
* write (modify) it and
* execute it.

Unix permissions specify what can the owner group do, and what can everybody
else do with the file.

    rwxr-xr-x   means is that the
        rwx     owner can do anything with the file,
        r-x     but group owners and the
        r-x     rest of the world can only read or execute it.

    Example:

    [nick@thekla src]$ ls -l
    -rwxr-xr-x 1 nick users 382 Jan 19 11:49 bscoped.pl
    drwxr-xr-x 3 nick users 1024 Jan 19 11:19 lib/
    -rwxr-xr-x 1 nick users 1874 Jan 19 10:23 socktest.pl

Directories
-----------
* read determines if a user can view the directory's contents, i.e. do ls in it.
* write determines if a user can create new files or delete file in the directory.
(Note here that this essentially means that a user with write access toa directory
can delete files in the directory even if he/she doesn't have write permissions
for the file!)
* execute determines if the user can cd into the directory.

chmod
-----
only the owner of a file may use chmod to alter a file's permissions.