// We’ll need to combine the  path_provider plugin with the dart:io library
//
//
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

// Find the correct local path
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  print("directory.path is : " + directory.path);
  return directory.path;
}

// Create a reference to the file location
Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}

// Write data to the file
Future<File> writeCounter(int counter) async {
  final file = await _localFile;
  return file.writeAsString('$counter');
}

// Read data from the file
Future<int> readCounter() async {
  try {
    final file = await _localFile;
    String contents = await file.readAsString();

    return int.parse(contents);
  } catch (e) {
    return 0;
  }
}

