import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
class savingData extends StatefulWidget {
  const savingData({Key? key}) : super(key: key);

  @override
  _savingDataState createState() => _savingDataState();
}

class _savingDataState extends State<savingData> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(storage: CounterStorage(),),
    );
  }
}
//------------
class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}
//------------------------
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.storage}) : super(key: key);

  final CounterStorage storage;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _counter = 0;
  int _counterfile = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counterfile = value;
      });
    });
  }

  Future<File> _incrementCounterf() {
    setState(() {
      _counterfile++;
    });

    // Write the variable as a string to the file.
    return widget.storage.writeCounter(_counterfile);
  }

  //Loading counter value on start
  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0);
    });
  }

  //Incrementing counter after click
  void _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', _counter);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('saving reading datasas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed:_incrementCounter,
              child: const Text('счетчик с shared_preferences'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed:_incrementCounterf,
              child: const Text('счетчик записи данныхв файл'),
            ),
            const SizedBox(height: 15),
            Text('показания из shared_preferences: $_counter'),
            const SizedBox(height: 15),
            Text('показания из файла: $_counterfile'),
          ],
        ),
      ),
    );
  }
}