import 'dart:convert';
import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

bool isReadOnly = true;
bool isInteractive = true;

File? databaseFile;
String? command;
Database? database;

/// Returns a value if provided
executeCommand(String sqliteCommand) {
  try {
    if (sqliteCommand.toLowerCase().trim().startsWith('select')) {
      return database!.select(sqliteCommand);
    }else{
      database!.execute(sqliteCommand);
      return "";
    }
  }catch (ex) {
    return (ex as SqliteException).message.toString();
  }
}

void processOutputForTerminal(Object obj) {

}

void interactiveLoop() {
  while (true) {
    stdout.write(": ");
    String? userinput = stdin.readLineSync(encoding: utf8, retainNewlines: false);
    if (userinput == null) continue;
    if (userinput.isEmpty) continue;

    String execResult = (executeCommand(userinput) ?? "").toString();
    print(execResult);
  }
}

void loadFile(String path) {
  databaseFile = File.fromUri(Uri.parse(path));
}

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('SQLite CLI - Execute commands and manage SQLite databases directly from terminal.');
    print(' Usage example: sqlite <flags> <file> <command>');
    print(' Available Commands:');
    print('  -r - Opens the database in read only. (Default: true)');
    print('  -w - Opens the database with write access.');
    print('  -c - Directly executes command to the database.');
    print('  -i - Interactive mode. (Defaults to true if -c is not supplied)');
    print('');
    print('Note: If specified file does not exist, it will be created after execution.');
    return;
  }

  // Process each argument
  for(String arg in arguments) {
    // Process non-flag arguments
    if (!arg.startsWith('-')) {
      // Get database file path
      if (databaseFile == null) {
        loadFile(arg);
        continue;
      }

      // Get command
      command = arg;
      continue;
    }

    // Process flags each argument
    for(int i = 1; i < arg.length; i++) {
      String flag = arg[i].toLowerCase();

      switch(flag) {
        case "i":
          isInteractive = true;
          break;
        case "w":
          isReadOnly = false;
          break;
        case "c":
          isInteractive = false;
          break;
        default:
          stderr.writeln("Unknown flag '-$flag'!");
          exit(1);
      }
    }
  }

  // Connect to the database
  if (databaseFile != null) {
    if (databaseFile!.existsSync()) {
      if (isReadOnly) {
        print("Warning: Read-only mode");
      }
      database = sqlite3.open(databaseFile!.path, mode: isReadOnly ? OpenMode.readOnly : OpenMode.readWrite);
    }else{
      database = sqlite3.open(databaseFile!.path, mode: OpenMode.readWriteCreate);
    }
  }else{
    print("Warning: No file specified, any changes will not be saved!");
    database = sqlite3.openInMemory();
  }
  
  print("Ctrl+C to exit the app.");

  // Start app
  if (isInteractive) {
    interactiveLoop();
  }else{

  }
}
