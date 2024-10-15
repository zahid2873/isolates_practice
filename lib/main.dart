import 'dart:isolate';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/animation.gif"),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  double total = await taskWithoutIsolate();
                  debugPrint("Total: $total");
                },
                child: const Text("TaskWithoutIsolate")),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  final receivePort = ReceivePort();
                  Isolate.spawn(taskWithIsolate, receivePort.sendPort);
                  receivePort.listen((total) {
                    debugPrint("Total: $total");
                  });
                },
                child: const Text("TaskWithtIsolate"))
          ],
        ),
      ),
    );
  }

  Future<double> taskWithoutIsolate() async {
    double total = 0.0;
    for (var i = 0; i < 1000000000; i++) {
      total += i;
    }
    return total;
  }
}

taskWithIsolate(SendPort sendPort) async {
  double total = 0.0;
  for (var i = 0; i < 1000000000; i++) {
    total += i;
  }
  sendPort.send(total);
}
