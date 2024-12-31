// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:spa_mobile/features/home/presentation/blocs/image_bloc.dart';
//
// class TakeImageScreen extends StatefulWidget {
//   const TakeImageScreen({super.key});
//
//   @override
//   State<TakeImageScreen> createState() => _TakeImageScreenState();
// }
//
// class _TakeImageScreenState extends State<TakeImageScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => ImageBloc(),
//       child: Scaffold(
//         appBar: AppBar(title: Text("Image Validation")),
//         body: BlocConsumer<ImageBloc, ImageState>(
//           listener: (context, state) {
//             // if (state is ImageInvalid) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(state.error)),
//               );
//             } else if (state is ImageValid) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text("Image is valid!")),
//               );
//             }
//           },
//           builder: (context, state) {
//             if (state is ImageLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is ImagePicked) {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.file(File(state.imagePath)),
//                   SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       context
//                           .read<ImageBloc>()
//                           .add(ValidateImageEvent(state.imagePath));
//                     },
//                     child: Text("Validate Image"),
//                   ),
//                 ],
//               );
//             }
//
//             return Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   context.read<ImageBloc>().add(PickImageEvent());
//                 },
//                 child: Text("Pick Image"),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class FaceDetectionCamera extends StatefulWidget {
//   @override
//   _FaceDetectionCameraState createState() => _FaceDetectionCameraState();
// }
//
// class _FaceDetectionCameraState extends State<FaceDetectionCamera> {
//   late CameraController _cameraController;
//   late List<CameraDescription> _cameras;
//   bool _isFaceInsideOval = false;
//   bool _isCameraInitialized = false;
//   late FaceDetector _faceDetector;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _faceDetector = GoogleMlKit.vision.faceDetector(
//       FaceDetectorOptions(
//         enableContours: true,
//         enableClassification: true,
//       ),
//     );
//   }
//
//   Future<void> _initializeCamera() async {
//     final status = await Permission.camera.status;
//     if (!status.isGranted) {
//       final requestStatus = await Permission.camera.request();
//       if (!requestStatus.isGranted) {
//         // emit(ImageInvalid("Permission to access photos is denied."));
//         return;
//       }
//     }
//     if (status.isDenied || status.isPermanentlyDenied) {
//       // emit(ImageInvalid("Permission to access photos is denied. Please enable it in settings."));
//       if (status.isPermanentlyDenied) {
//         await openAppSettings();
//       }
//       return;
//     }
//     _cameras = await availableCameras();
//     _cameraController = CameraController(
//       _cameras[1],
//       ResolutionPreset.high,
//     );
//     await _cameraController.initialize();
//     setState(() {
//       _isCameraInitialized = true;
//     });
//     _startImageStream();
//   }
//
//   void _startImageStream() {
//     _cameraController.startImageStream((CameraImage image) async {
//       final WriteBuffer allBytes = WriteBuffer();
//       for (var plane in image.planes) {
//         allBytes.putUint8List(plane.bytes);
//       }
//       final inputImage = InputImage.fromBytes(
//         bytes: allBytes.done().buffer.asUint8List(),
//          inputImageData: InputImageData(
//           size: Size(image.width.toDouble(), image.height.toDouble()),
//           imageRotation: InputImageRotationMethods.fromRawValue(
//               _cameraController.description.sensorOrientation) ??
//               InputImageRotation.Rotation_0deg,
//           inputImageFormat:
//           InputImageFormatMethods.fromRawValue(image.format.raw) ??
//               InputImageFormat.NV21,
//           planeData: image.planes.map((Plane plane) {
//             return InputImagePlaneMetadata(
//               bytesPerRow: plane.bytesPerRow,
//               height: plane.height,
//               width: plane.width,
//             );
//           }).toList(),
//         ),
//       );
//
//       final faces = await _faceDetector.processImage(inputImage);
//       if (faces.isNotEmpty) {
//         // Kiểm tra nếu khuôn mặt nằm trong hình bầu dục
//         setState(() {
//           _isFaceInsideOval = true; // Bạn có thể thêm logic kiểm tra vị trí mặt
//         });
//       } else {
//         setState(() {
//           _isFaceInsideOval = false;
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _cameraController.dispose();
//     _faceDetector.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Face Detection Camera")),
//       body: _isCameraInitialized
//           ? Stack(
//         children: [
//           CameraPreview(_cameraController),
//           Center(
//             child: Container(
//               width: 300,
//               height: 400,
//               decoration: BoxDecoration(
//                 shape: BoxShape.rectangle,
//                 borderRadius: BorderRadius.circular(200),
//                 border: Border.all(
//                   color: _isFaceInsideOval ? Colors.green : Colors.red,
//                   width: 3,
//                 ),
//               ),
//             ),
//           ),
//           if (!_isFaceInsideOval)
//             Center(
//               child: Text(
//                 "Please align your face in the oval",
//                 style: TextStyle(color: Colors.red, fontSize: 16),
//               ),
//             ),
//           if (_isFaceInsideOval)
//             Positioned(
//               bottom: 20,
//               right: 20,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   final image = await _cameraController.takePicture();
//                   // Xử lý hình ảnh chụp được
//                   AppLogger.info("Image saved to: ${image.path}");
//                 },
//                 child: Text("Capture"),
//               ),
//             ),
//         ],
//       )
//           : Center(child: CircularProgressIndicator()),
//     );
//   }
// }
