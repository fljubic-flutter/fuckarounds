import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:fuckarounds/riverpod/mvvm/joke_view_model.dart';
import 'joke_model.dart';

/// sta zapravo zelim isprobati s ovime:
/// -kako napraviti mvvm s Riverpodom
/// -ako se Provider ponasa kao singleton i ako ga onda moram
/// inicijalizirati u jednom fileu i importati u svaki (vjv da)
/// - opcenito zelim skuziti kada se koji tip Providera koristi - StateProvider, StateNotifierProvider, ChangeNotifierProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

final jokeViewModelProvider = ChangeNotifierProvider((ref) => JokeViewModel());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF6FD9E2),
        accentColor: const Color(0xFFDBDFB8),
        disabledColor: const Color(0xFFF2DDB2),
        iconTheme: IconThemeData(
          color: const Color(0xFF6FD9E2),
        ),
      ),
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              children: [
                Consumer(
                  builder: (context, watch, child) {
                    final jokeVM = watch(jokeViewModelProvider);
                    return Text(jokeVM.dadJoke.text);
                  },
                ),
                RaisedButton(onPressed: () {
                  context.read(jokeViewModelProvider).getDadJoke();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
