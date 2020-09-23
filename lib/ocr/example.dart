import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:translator/translator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Realtime translation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Realtime translation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  PickedFile _pickedImage;
  bool _isImageLoaded = false;
  bool _isTextLoaded = false;
  String _text = "";

  Future pickImage() async {
    var tempStore = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _pickedImage = tempStore;
      _isImageLoaded = true;
    });
  }

  Future readText() async {
    FirebaseVisionImage ourImage =
        FirebaseVisionImage.fromFile(File(_pickedImage.path));
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    translate(readText.text);
  }

  void translate(String readText) async {
    GoogleTranslator translator = GoogleTranslator();

    String input = readText;

    translator
        .translate(input, to: 'hr')
        .then((_translatedText) => setState(() {
              _text = _translatedText.text;
              _isTextLoaded = true;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            _isImageLoaded
                ? Center(
                    child: Container(
                      height: 200.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(File(_pickedImage.path)),
                              fit: BoxFit.cover)),
                    ),
                  )
                : Container(),
            _isTextLoaded ? Center(child: Text(_text)) : Container(),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              child: Text('Choose an image'),
              onPressed: pickImage,
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              child: Text('Read Text'),
              onPressed: readText,
            ),
          ],
        ));
  }
}
