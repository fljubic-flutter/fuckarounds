import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuckarounds/riverpod/mvvm/joke_view_model.dart';
import 'joke_model.dart';
import 'package:hooks_riverpod/all.dart';

/// sta zapravo zelim isprobati s ovime:
/// -kako napraviti mvvm s Riverpodom simple easy fun dominion
/// -ako se Provider ponasa kao singleton i ako ga onda moram
/// inicijalizirati u jednom fileu i importati u svaki (vjv da) yup
/// - opcenito zelim skuziti kada se koji tip Providera koristi - StateProvider, StateNotifierProvider, ChangeNotifierProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

final buttonProvider = StateProvider<bool>((ref) {
  return false;
});

final jokeViewModelProvider = FutureProvider<JokeSingle>((ref) async {
  return JokeViewModel.getDadJoke();
});

final notJokeViewModelProvider = FutureProvider<JokeSingle>((ref) async {
  final w = ref.watch(buttonProvider);

  return JokeViewModel.getDadJoke();
});

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    print("Whole MyApp built");
    final dadJoke = useProvider(jokeViewModelProvider);
    final otherDadJoke = useProvider(notJokeViewModelProvider);
    final pressed = useProvider(buttonProvider);

    String text = otherDadJoke.when(
        data: (val) => "${val.text}",
        loading: () => "loading",
        error: (e, s) => "error");

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
          body: dadJoke.when(
              loading: () => Center(child: const CircularProgressIndicator()),
              error: (Object error, StackTrace stackTrace) {
                return Center(child: Text("${error.toString()}"));
              },
              data: (JokeSingle value) {
                return Column(
                  children: [
                    Center(
                      child:
                          pressed.state ? Text("$text") : Text("${value.text}"),
                    ),
                    RaisedButton(onPressed: () {
                      print("dadJoke before pressed: ${value.text}");
                      pressed.state = !pressed.state;
                    }),
                    HookBuilder(builder: (context) {
                      final number = useState(0);

                      return RaisedButton(
                        onPressed: () {
                          number.value = number.value + 1;
                          print("only part rebuilt");
                        },
                        child: Text(number.value.toString()),
                      );
                    })
                  ],
                );
              }),
        ),
      ),
    );
  }
}
