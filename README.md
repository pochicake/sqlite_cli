# SQlite CLI

Tired of using SQLite Browser? or perhaps you have skill issue in using SQL and want the skibidi? 

> Do note that there are differences with SQLite commands and other SQL frameworks like MySQL, but this is a good starting point.

# Download

These are pre-compiled so you don't have to run through setting up compiling environments:

[Windows](), [Linux](), [MacOS]()

# Usage

Unless specified, the app will show the help information if no arguments are given. If no filepath is given, it will resort to in-memory mode, meaning the changes will not be saved and a warning is given.
You can execute commands directly without interactive mode by using the `-c` flag:

```cmd
C:\> sqlite -c test.db "SELECT name FROM test"
```

Database is opened in **read-only** mode if `w` is not provided! Here's how to execute modifications to an existing database:

```cmd
C:\> sqlite -wc test.db "CREATE TABLE a_table(id INTEGER PRIMARY KEY, name TEXT)
```

```cmd
C:\> sqlite -wc test.db "INSERT INTO a_table(name) VALUES('testing')"
```

Assuming the field is `BLOB`, if you wish to take out raw binaries from the database, you'll need to pipe the output to a file like this:

```cmd
C:\> sqlite -c test.db "SELECT raw_bytes FROM test WHERE id = 1" > file.bin
```

If the result is an entry and not a value, the piped data is encoded in JSON:

```cmd
C:\> sqlite -c test.db "SELECT * FROM test WHERE id = 1" > entry.json
```

You can add the binary to `PATH` and simply run commands like this:

```cmd
C:\> sqlite -c test.db "CREATE TABLE test(id INTEGER PRIMARY KEY, name TEXT)"
```

```cmd
C:\> sqlite -i
Ctrl+C to exit the app.
: CREATE TABLE test(id INTEGER PRIMARY KEY, name TEXT)
: INSERT INTO test(name) VALUES("hello")
: INSERT INTO test(name) VALUES("world")
: SELECT * FROM test
[{id: 1, name: hello}, {id: 2, name: world}]
```

# Building

First, clone the repo:

```cmd
git clone
```

Then compile the project:

```cmd
C:\sqlite_cli> dart compile exe bin\sqlite.dart
```

Then simply run the app:

```cmd
C:\sqlite_cli\bin> sqlite.exe
```