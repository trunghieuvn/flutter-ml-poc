import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class MLKitService {
  Future<List<String>> detectText(String filePath,
      {bool numberOnly = false}) async {
    final inputImage = InputImage.fromFile(File(filePath));

    final textRecognizer = GoogleMlKit.vision.textRecognizer();

    final recognisedText = await textRecognizer.processImage(inputImage);

    final textBlocks = recognisedText.blocks;
    if (numberOnly == false) {
      return textBlocks.map((e) => e.text).toList();
    }

    var result = <String>[];
    final idNumberRegex = RegExp(r'\b\d{9}\b|\b\d{12}\b');
    for (final block in textBlocks) {
      for (final line in block.lines) {
        for (final element in line.elements) {
          final text = element.text;
          if (idNumberRegex.hasMatch(text)) {
            if (kDebugMode) {
              print('ID Number: $text');
            }
            result.add(text);
          } else {
            if (kDebugMode) {
              print('=======> $text');
            }
          }
        }
      }
    }
  return result;
  }

}
