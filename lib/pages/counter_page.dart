import 'package:flutter/material.dart';

import '../databases/database_helper.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key, required this.title});

  final String title;

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;
  final nameController = TextEditingController();

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
            TextField(
              controller: nameController,
            ),
            ElevatedButton(
              onPressed: () {
                print(nameController.text);
              },
              child: const Text('Save'),
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () async {
                _counter++;

                List<Map<String, dynamic>> items =
                    await DatabaseHelper.getCounters();
                if (items.isEmpty) {
                  await DatabaseHelper.saveCounter(_counter);
                } else {
                  await DatabaseHelper.updateCounter(1, _counter);
                }
                print(items);
                setState(() {});
              },
              child: const Text('+'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_counter > 0) {
                  _counter--;

                  List<Map<String, dynamic>> items =
                      await DatabaseHelper.getCounters();
                  if (items.isEmpty) {
                    await DatabaseHelper.saveCounter(_counter);
                  } else {
                    await DatabaseHelper.updateCounter(1, _counter);
                  }
                  print(items);
                  setState(() {});
                }
              },
              child: const Text('-'),
            ),
            ElevatedButton(
              onPressed: () async {
                _counter = 0;

                List<Map<String, dynamic>> items =
                    await DatabaseHelper.getCounters();
                if (items.isNotEmpty) {
                  await DatabaseHelper.updateCounter(1, 0);
                }
                print(items);
                setState(() {});
              },
              child: const Text('reset'),
            ),
          ],
        ),
      ),
    );
  }
}
