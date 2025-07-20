import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class TfliteService {
  late Interpreter _interpreter;
  late List<String> _labels;
  bool _isModelLoaded = false;

  Future<void> loadModel() async {
    try {
      // Load the model and labels
_interpreter = await Interpreter.fromAsset('assets/model_comp.tflite');
      final labelsData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsData.split('\n');
      _isModelLoaded = true;
      print('Model and labels loaded');
    } catch (e) {
      print("Failed to load model: $e");
      rethrow; // Pastikan terlempar agar interpreter tidak tetap uninitialized
    }
  }

  Future<Map<String, double>> classifyImage(Uint8List imageBytes) async {
    if (!_isModelLoaded) {
      throw Exception("Model is not loaded yet. Please call loadModel() first.");
    }

    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) return {};

    img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

    var buffer = Float32List(1 * 224 * 224 * 3);
    var pixelIndex = 0;
    for (var i = 0; i < 224; i++) {
      for (var j = 0; j < 224; j++) {
        var pixel = resizedImage.getPixel(j, i);
        buffer[pixelIndex++] = (pixel.r - 127.5) / 127.5;
        buffer[pixelIndex++] = (pixel.g - 127.5) / 127.5;
        buffer[pixelIndex++] = (pixel.b - 127.5) / 127.5;
      }
    }

    var input = buffer.reshape([1, 224, 224, 3]);
    var output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);

    _interpreter.run(input, output);

    var outputList = output[0] as List<double>;
    var highestProbability = outputList.reduce((a, b) => a > b ? a : b);
    var highestProbabilityIndex = outputList.indexOf(highestProbability);
    var label = _labels[highestProbabilityIndex];

    return {label: highestProbability};
  }

  void dispose() {
    if (_isModelLoaded) {
      _interpreter.close();
    }
  }
}
