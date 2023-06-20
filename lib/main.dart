import 'package:flutter/material.dart';
import 'package:pushup_counter/databases/database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    initData();
    super.initState();
  }

  Future<void> initData() async {
    List<Map<String, dynamic>> items = await DatabaseHelper.getCounters();
    if (items.isEmpty) {
      _counter = 0;
    } else {
      Map<String, dynamic> item = items[0];
      _counter = item['count'];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _counter++;
                });
                List<Map<String, dynamic>> items =
                    await DatabaseHelper.getCounters();
                if (items.isEmpty) {
                  await DatabaseHelper.saveCounter(_counter);
                } else {
                  await DatabaseHelper.updateCounter(1, _counter);
                }
                print(items);
              },
              child: const Text('+'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_counter > 0) {
                  setState(() {
                    _counter--;
                  });
                  List<Map<String, dynamic>> items =
                      await DatabaseHelper.getCounters();
                  if (items.isEmpty) {
                    await DatabaseHelper.saveCounter(_counter);
                  } else {
                    await DatabaseHelper.updateCounter(1, _counter);
                  }
                  print(items);
                }
              },
              child: const Text('-'),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _counter = 0;
                });
                List<Map<String, dynamic>> items =
                    await DatabaseHelper.getCounters();
                if (items.isNotEmpty) {
                  await DatabaseHelper.updateCounter(1, 0);
                }
                print(items);
              },
              child: const Text('reset'),
            ),
          ],
        ),
      ),
    );
  }
}
