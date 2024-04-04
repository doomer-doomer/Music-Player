// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:image/image.dart' as img;
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:http/http.dart' as http;


// class Emotion extends StatefulWidget {
//   final String imagePath;
//   const Emotion({super.key, required this.imagePath});

//   @override
//   State<Emotion> createState() => _EmotionState();
// }

// class _EmotionState extends State<Emotion> {

//   String detected = '';

//   @override
//   void initState() {
//     super.initState();
//     processImageWithTFLite(widget.imagePath);
//   }

  

//   Future<void> processImageWithTFLite(String imagePath) async {
//   // Load the TensorFlow Lite model
 

//   // Read the image from the file path
//   final File imageFile = File(imagePath);
//   var url = Uri.http('10.0.2.2',':5000/img');
  
//    var request = http.MultipartRequest('POST', url);

//    var filePart = http.MultipartFile(
//       'file', // Key of the file
//       imageFile!.readAsBytes().asStream(),
//       imageFile!.lengthSync(),
//       filename: imageFile!.path.split('/').last,
//     );
//     request.files.add(filePart);
//     var response = await request.send();
//     if (response.statusCode == 200) {
//       // File uploaded successfully
//       print('File uploaded successfully');
//       print(response);
//       setState(() {
//         detected = response.toString();
//       });
//     } else {
//       // Error occurred
//       print('Failed to upload file. Status code: ${response.statusCode}');
//     }
  
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(children: [
        
//         Image.file(File(widget.imagePath)),
//         Text('${detected}',style: TextStyle(

//         ),),
//         ]),
    
//     );
//   }
// }