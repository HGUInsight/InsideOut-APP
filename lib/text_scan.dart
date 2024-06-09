import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class TextScan extends StatefulWidget {
  const TextScan({super.key});

  @override
  State<TextScan> createState() => _TextScanState();
}

class _TextScanState extends State<TextScan> {
  File? _image;
  String _recognizedText = '';

  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      recognizeText(_image!);
    }
  }

  Future recognizeText(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    setState(() {
      _recognizedText = recognizedText.text;
    });

    await textRecognizer.close();
    saveRecognizedText(_recognizedText);
  }

  Future saveRecognizedText(String text) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/recognized_text.txt');
    await file.writeAsString(text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Text saved to ${file.path}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ML Kit Text Recognition'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : Image.file(_image!),
            SizedBox(height: 20),
            Text(_recognizedText),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => getImage(ImageSource.camera),
            tooltip: 'Pick Image from Camera',
            child: Icon(Icons.add_a_photo),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => getImage(ImageSource.gallery),
            tooltip: 'Pick Image from Gallery',
            child: Icon(Icons.photo_library),
          ),
        ],
      ),
    );
  }
}
