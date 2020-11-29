import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      // za storeanje statea svih providera
      ProviderScope(
        child: MyApp(),
      ),
    );

// provider is not global, only its definition
final greetingProvider = Provider((ref) => 'greeting from Provider');

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final String greeting =
        watch(greetingProvider); //svaki change bi rebuildao widget
    return MaterialApp(
      title: "Riverpod tutorial",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Riverpod Tutorial"),
        ),
        body: Center(
          child: Text(greeting),
        ),
      ),
    );
  }
}

// drugi nacin je s Consumerom, vise je efficient jer ne rebuilda sve
class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Riverpod tutorial",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Riverpod Tutorial"),
        ),
        body: Center(
          child: Consumer(
            builder: (context, watch, child) {
              final String greeting = watch(greetingProvider);
              return Text(greeting);
            },
          ),
        ),
      ),
    );
  }
}

// u ova 2 nije moguce ako treba watchat nesto u nekoj funkciji
// tipa za button press ili tako nes

class IncrementNotifier extends ChangeNotifier {
  int _value = 0;
  int get value => _value;

  void increment() {
    _value++;
    notifyListeners();
  }
}

final incrementProvider = ChangeNotifierProvider((ref) => IncrementNotifier());

class MyCounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Riverpod tutorial",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Riverpod Tutorial"),
        ),
        body: Center(
          child: Consumer(
            builder: (context, watch, child) {
              final incrementNotifier = watch(incrementProvider);
              return Text(incrementNotifier.value.toString());
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // ovaj dio di ne mozemo watchat
            context.read(incrementProvider).increment();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
