import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuckarounds/riverpod/mvvm/joke_model.dart';
import 'package:http/http.dart' as http;

class JokeViewModel extends ChangeNotifier {
  JokeSingle dadJoke = JokeSingle(text: "Nothing yet!");

  Future<JokeSingle> getDadJoke() async {
    final http.Response response =
        await http.get("https://icanhazdadjoke.com/");

    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);

      dadJoke = JokeSingle(text: decode["joke"]);
      print(dadJoke.text);

      notifyListeners();
      return dadJoke;
    } else {
      dadJoke = JokeSingle(
        text: "No internet connection :(",
      );
    }
  }
}
