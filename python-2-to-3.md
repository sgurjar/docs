# Python 2 to 3

~~~~
# python 2
print "Hello", "world!"
> Hello world!

# python 3
print("Hello", "world!")
> Hello world!

# In Python 2.6+
from __future__ import print_function
print("Hello", "world!")
> Hello world!
~~~~

The `print` statement doesn't work in Python 3. If you want to print
something and have it work in both Python versions, you'll need to import
`print_function` in your Python 2 code.
