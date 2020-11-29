import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

// ono za sta sam inace koristio get_it

void main() {
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class FakeHttpClient {
  Future<String> get(String url) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Response from $url';
  }
}

final fakeHttpClientProvider = Provider((ref) => FakeHttpClient());
final responseProvider =
    FutureProvider.family<String, String>((ref, inputUrl) async {
  final httpClient = ref.read(fakeHttpClientProvider);
  // watch() ako mislimo da ce se promjenit
  return httpClient.get(inputUrl);
});
// jedino zas je futureprovider drukciji je da ima async

// car Riverpoda je da je dobivanje data iz FutureProvidera i StreamProvidera
// na istu foru kao kod obicnog Providera
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Consumer(
            builder: (context, watch, child) {
              // state ne bude disposean tj.
              // ako je nes vec requestano bilo onda je samo cacheano
              // ako ne zelimo da bude cacheano stavimo .autoDispose ispred .family
              final AsyncValue responseAsyncValue =
                  watch(responseProvider('https://fakeapi.com'));
              // AsyncValue je union
              return responseAsyncValue.map(
                data: (_) => Text(_.value), //kada je data unutra sta vratiti
                loading: (_) => CircularProgressIndicator(),
                error: (_) => Text(
                  "Error :( ${_.error.toString()}",
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ako zelimo da korisnik upise nes u provider koristimo .family
// pa treba malo promjeniti watch i definiciju FutureProvidera
