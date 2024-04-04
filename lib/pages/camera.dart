// import 'dart:isolate';

// import 'package:flutter/material.dart';
// import 'package:testz/pages/model/classifier.dart';
// import 'package:testz/pages/emotion.dart';
// import 'package:camera/camera.dart';
// import 'dart:typed_data';
// import 'package:image/image.dart' as img;
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:testz/pages/model/isolateUtils.dart';
// import 'dart:ui' as fui;
// //import 'package:tflite_v2/tflite_v2.dart';


// class Camera extends StatefulWidget {
//   final List<CameraDescription> cameras;
//   const Camera({super.key, required this.cameras});

//   @override
//   State<Camera> createState() => _CameraState();
// }

// class _CameraState extends State<Camera> {
//     // late Interpreter _interpreter;
//     // final classifier = Classifier();
//     final isolateUtils = IsolateUtils();

//   late CameraController controller;
  
// //   bool _isPredicting = false;
//   bool initialized = false;
// // DetectionClasses detected = DetectionClasses.Neutral;
// //   bool isWorking = false;
  

//   @override
//   void initState() {
//     super.initState();
    
   
//     controller = CameraController(widget.cameras[1], ResolutionPreset.veryHigh);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       initModel();
//      controller.startImageStream((image) {
//       objectDetector(image);
//       // Make predictions only if not busy
     
//         // processCameraImage(image);
//       //   Classifier classifier = Classifier();
//       // // Restore interpreter from main isolate
    

//       // final convertedImage = ImageUtils.convertYUV420ToImage(image);
//       // classifier.predict(convertedImage).then((value) => setState(() {
//       //   detected = value;
//       // }));
        
      
//     });
//       setState(() {
//         initialized = true;
//       });
      
//     }).catchError((Object e) {
//       if (e is CameraException) {
//         switch (e.code) {
//           case 'CameraAccessDenied':
//             // Handle access errors here.
//             break;
//           default:
//             // Handle other errors here.
//             break;
//         }
//       }
//     });
//   }

//   initModel() async{
//     await Tflite.loadModel(
//       model: "assets/RAF-DB794.tflite",
//       labels: "assets/labels.txt",
//       isAsset: true,
//       useGpuDelegate: false,
//       numThreads: 1
//     );

//     print("Model Loaded");
//   }

//   objectDetector(CameraImage image)async{
//     var detector = await Tflite.detectObjectOnFrame(
//       bytesList: image.planes.map((plane) {
//         return plane.bytes;
//       }).toList(),
//       asynch: true,
//       imageHeight: image.height,
//       imageWidth: image.width,
//       imageMean: 127.5,
//       imageStd: 127.5,
//       numResultsPerClass: 7,
//       threshold: 0.1,
      
//     );
//     List<List<double>> javaObject = [];
// for (var detection in detector!) {
//   // Assuming each detection contains 7 attributes
//   List<double> flattenedDetection = [
//     detection["x"],  // Example attribute 1
//     detection["y"],  // Example attribute 2
//     detection["w"],  // Example attribute 3
//     detection["h"],  // Example attribute 4
//     detection["confidence"],  // Example attribute 5
//     detection["class"],  // Example attribute 6
//     detection["index"]   // Example attribute 7
//   ];
//   javaObject.add(flattenedDetection);
// }

//   }

// //   Future<DetectionClasses> predict(img.Image image) async {
// //     img.Image resizedImage = img.copyResize(image, width: 100, height: 100);

// //     // Convert the resized image to a 1D Float32List.
// //     Float32List inputBytes = Float32List(100 * 100 * 3);
// //     int pixelIndex = 0;
// //     for (int y = 0; y < resizedImage.height; y++) {
// //       for (int x = 0; x < resizedImage.width; x++) {
// //         final pixel = resizedImage.getPixel(x, y);
// //         inputBytes[pixelIndex++] = pixel.r / 127.5 - 1.0;
// //         inputBytes[pixelIndex++] = pixel.g / 127.5 - 1.0;
// //         inputBytes[pixelIndex++] = pixel.b / 127.5 - 1.0;
// //       }
// //     }

// //     // Reshape to input format specific for model. 1 item in list with pixels 100x100 and 3 layers for RGB
// //     final input = inputBytes.reshape([1, 100, 100, 3]);

// //     // Output container
// //     final output = Float32List(1 * 4).reshape([1, 4]); 

// //     // Run data throught model
// //     _interpreter.run(input, output);

// //     // Get index of maxumum value from outout data. Remember that models output means:
// //     // Index 0 - rock, 1 - paper, 2 - scissor, 3 - nothing.
// //     final predictionResult = output[0] as List<double>;
// //     double maxElement = predictionResult.reduce(
// //       (double maxElement, double element) =>
// //           element > maxElement ? element : maxElement,
// //     );
// //     return DetectionClasses.values[predictionResult.indexOf(maxElement)];
// //   }

// //   initializeInterpreter() async{
// //     _interpreter = _interpreter ??
// //         await Interpreter.fromAsset(
// //           'assets/RAF-DB794.tflite',
// //           options: InterpreterOptions()..threads = 4,
// //         );

// //     _interpreter.allocateTensors();
// //   }

// //   Future<void> processCameraImage(CameraImage cameraImage) async {
// //   setState(() {
// //     isWorking = true;
// //   });

// //   Classifier classifier = Classifier();
// //       // Restore interpreter from main isolate
    

// //       final convertedImage = ImageUtils.convertYUV420ToImage(cameraImage);
// //       DetectionClasses results = await classifier.predict(convertedImage);

// //   if (detected != results) {
// //     setState(() {
// //       detected = results;
// //     });
// //   }

// //   setState(() {
// //     //lastShot = DateTime.now();
// //     isWorking = false;
// //   });
// // }

// // Future<void> _initializeInterpreterIfNeeded() async {
// //   if (_interpreter == null) {
// //     // Initialize the interpreter if it's not already initialized
// //     await _loadModel();
// //   }
// // }
// //   @override
// //   void dispose() {
// //     controller.dispose();
// //     isolateUtils.dispose();
// //     _interpreter.close();
// //     super.dispose();
// //   }

//   void takePicture() async {
//     if (!controller.value.isInitialized) {
//       return;
//     }

//     // Construct the path where the image should be saved using the path_provider plugin.
//     final Directory? extDir = await getExternalStorageDirectory();
//     final String dirPath = '${extDir!.path}/Pictures/flutter_test';
//     await Directory(dirPath).create(recursive: true);

//     // Construct the path where the image should be saved
//     final String filePath = '$dirPath/${DateTime.now()}.jpg';

//     // Attempt to take a picture and log where it's been saved
//     try {
//       XFile picture = await controller.takePicture();

//       // Save the picture to the desired location
//       File(picture.path).copy(filePath);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Emotion(imagePath: filePath),
//         ),
//       );
//     } catch (e) {
//       print(e);
//     }
//   }

// //   Future<DetectionClasses> inference(CameraImage cameraImage) async {
// //   ReceivePort responsePort = ReceivePort();
// //   final isolateData = IsolateData(
// //     cameraImage: cameraImage,
// //     interpreterAddress: classifier.interpreter.address,
// //     responsePort: responsePort.sendPort,
// //   );

// //   isolateUtils.sendPort.send(isolateData);
// //   var result = await responsePort.first;

// //   return result;
// // }

 



// //   Future<void> _loadModel() async {
// //     _interpreter = await Interpreter.fromAsset(
// //       'assets/RAF-DB794.tflite',
// //       options: InterpreterOptions()..threads = 4,
// //     );
// //     _interpreter.allocateTensors();
// //     //await classifier.loadModel(interpreter: _interpreter);
// //     await isolateUtils.start();
    
// //   }

  
//  @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return Container();
//     }
//     return MaterialApp(
//       home: Scaffold(
      
//         body: initialized ? Stack(
//           alignment: Alignment.topCenter,
//           children: [
            
//           CameraPreview(controller),
//            Text(
//                   "Emotion Detector",
//                   style: const TextStyle(
//                     fontSize: 28,
//                     color: Colors.blue,
//                   ),
//                 ),

//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: EdgeInsets.only(bottom: 26.0),
              
//               child: FloatingActionButton(
//                 onPressed: takePicture,
//                 child: Icon(Icons.camera),
//               ),
//             ),
//           ),
          
//           ]) : const Center(child: CircularProgressIndicator()),
        
      
//       ),
      
//     );
//   }
// }

// class ImageUtils {
//   /// Converts a [CameraImage] in YUV420 format to [imageLib.Image] in RGB format
//   static img.Image convertYUV420ToImage(CameraImage cameraImage) {
//     final int width = cameraImage.width;
//     final int height = cameraImage.height;

//     final int uvRowStride = cameraImage.planes[1].bytesPerRow;
//     final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

 

//     final image = img.Image(width: width, height: height);

//     for (int w = 0; w < width; w++) {
//       for (int h = 0; h < height; h++) {
//         final int uvIndex =
//             uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
//         var index = h * width + w;

//         final y = cameraImage.planes[0].bytes[index];
//         final u = cameraImage.planes[1].bytes[uvIndex];
//         final v = cameraImage.planes[2].bytes[uvIndex];

//         img.Color rgb = ImageUtils.yuv2rgb(y, u, v) as img.Color;

//         //image.setPixel(w, h, fui.Color(ImageUtils.yuv2rgb(y, u, v)));

//       }
//     }
//     return image;
//   }

//   /// Convert a single YUV pixel to RGB
//   static int yuv2rgb(int y, int u, int v) {
//     // Convert yuv pixel to rgb
//     int r = (y + v * 1436 / 1024 - 179).round();
//     int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
//     int b = (y + u * 1814 / 1024 - 227).round();

//     // Clipping RGB values to be inside boundaries [ 0 , 255 ]
//     r = r.clamp(0, 255);
//     g = g.clamp(0, 255);
//     b = b.clamp(0, 255);

//     return 0xff000000 |
//     ((b << 16) & 0xff0000) |
//     ((g << 8) & 0xff00) |
//     (r & 0xff);
//   }
// }

