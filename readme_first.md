# Refactoring Challenge

During support we sometimes write some quickfix solutions, which we think will
not be needed apart from that one time task. Thus the code usually has no
tests, is not documented and just everything in one large file. Attached you
find an example for such an assumed one time task - modifier.rb.

Please do the following:

- give a short explanation of what the code actually does.
- refactor the code and ensure that the refactored code does the same
  as before.
- create a git repository containing the initial files and do regular
  and small commits to log your process.
- send me your git bundle containing your changes.






Extra definition

-The project read a file and parse it as CSV then sort rows by the given column(KEYWORD_UNIQUE_ID).
-Extract some data by main.rb#hash_modifier_list 
-The sorted output goes to some files which are limited by the user(120000line) and they will be indexed from 0 to ...
