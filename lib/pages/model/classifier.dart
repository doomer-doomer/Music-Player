// import 'dart:math';

// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as img;
// import 'dart:typed_data';

// enum DetectionClasses { Suprised, Fear, Disgusted, Happy,Sad , Angry, Neutral}

// class Classifier {
//   /// Instance of Interpreter
//   late Interpreter _interpreter;

//   static const String modelFile = "RAF-DB794.tflite";

//   Future<DetectionClasses> predict(img.Image image) async {
//     img.Image resizedImage = img.copyResize(image, width: 100, height: 100);

//     // Convert the resized image to a 1D Float32List.
//     Float32List inputBytes = Float32List(100 * 100 * 3);
//     int pixelIndex = 0;
//     for (int y = 0; y < resizedImage.height; y++) {
//       for (int x = 0; x < resizedImage.width; x++) {
//         final pixel = resizedImage.getPixel(x, y);
//         inputBytes[pixelIndex++] = pixel.r / 127.5 - 1.0;
//         inputBytes[pixelIndex++] = pixel.g / 127.5 - 1.0;
//         inputBytes[pixelIndex++] = pixel.b / 127.5 - 1.0;
//       }
//     }

//     // Reshape to input format specific for model. 1 item in list with pixels 100x100 and 3 layers for RGB
//     final input = inputBytes.reshape([1, 100, 100, 3]);

//     // Output container
//     final output = Float32List(1 * 4).reshape([1, 4]); 

//     // Run data throught model
//     interpreter.run(input, output);

//     // Get index of maxumum value from outout data. Remember that models output means:
//     // Index 0 - rock, 1 - paper, 2 - scissor, 3 - nothing.
//     final predictionResult = output[0] as List<double>;
//     double maxElement = predictionResult.reduce(
//       (double maxElement, double element) =>
//           element > maxElement ? element : maxElement,
//     );
//     return DetectionClasses.values[predictionResult.indexOf(maxElement)];
//   }

//   /// Loads interpreter from asset
//   Future<void> loadModel({Interpreter? interpreter}) async {
//     try {
//        if (_interpreter != null) {
//       print("Interpreter is already initialized.");
//       return;
//     }
//       _interpreter = interpreter ??
//           await Interpreter.fromAsset(
//             modelFile,
//             options: InterpreterOptions()..threads = 4,
//           );

//       _interpreter.allocateTensors();
//     } catch (e) {
//       print("Error while creating interpreter: $e");
//     }
//   }

//   /// Gets the interpreter instance
//   Interpreter get interpreter => _interpreter;
// }