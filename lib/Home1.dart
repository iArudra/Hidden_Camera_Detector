/*
//With Exposure
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  bool hiddenCameraDetected = false;
  bool processing = false;
  Timer? timer;
  Rect? boundingBox;

  @override
  void initState() {
    super.initState();
    startCamera();
  }

  @override
  void dispose() {
    cameraController.dispose();
    timer?.cancel();
    super.dispose();
  }


  Future<void> startCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await cameraController.initialize();
    await cameraController.setFlashMode(FlashMode.off);
    // await cameraController.setExposureMode(ExposureMode.locked);
    // await cameraController.setExposureOffset(-1.5);


    // Start processing frames after the camera is initialized
    timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (!processing) {
        processCameraFrame();
      }
    });

    setState(() {});
  }

  // Process the live camera frame
  Future<void> processCameraFrame() async {
    processing = true;

    try {
      XFile imageFile = await cameraController.takePicture();
      List<int> imageBytes = await imageFile.readAsBytes();
      img.Image? decodedImage = img.decodeImage(imageBytes);
      if (decodedImage != null) {
        bool foundHighIntensity = checkForHighIntensityPixels(decodedImage);
        if (hiddenCameraDetected != foundHighIntensity) {
          setState(() {
            hiddenCameraDetected = foundHighIntensity;
          });
        }
      }
    } catch (e) {
      print("Error processing camera frame: $e");
    }
    processing = false;
  }

  bool checkForHighIntensityPixels(img.Image image) {
    int minX = image.width, minY = image.height;
    int maxX = 0, maxY = 0;
    bool found = false;
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixel = image.getPixel(x, y);
        int red = img.getRed(pixel);
        int green = img.getGreen(pixel);
        int blue = img.getBlue(pixel);

        // If RGB values are greater than 240, assume a hidden camera
        if (red > 250 && blue > 15 && 110> green && green>90 ) {
          // Update bounding box coordinates
          minX = x < minX ? x : minX;
          minY = y < minY ? y : minY;
          maxX = x > maxX ? x : maxX;
          maxY = y > maxY ? y : maxY;
          found = true;
        }
      }
    }

    if (found) {
      boundingBox = Rect.fromLTRB(
        minX.toDouble(),
        minY.toDouble(),
        maxX.toDouble(),
        maxY.toDouble(),
      );
      return true;
    } else {
      boundingBox = null;
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Hidden Camera Detector",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          if (cameraController.value.isInitialized)
            Expanded(
              child: Stack(
                children: [
                  CameraPreview(cameraController),
                  if (boundingBox != null)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: BoundingBoxPainter(
                          boundingBox!,
                          cameraController.value.previewSize!.width,
                          cameraController.value.previewSize!.height,
                        ),
                      ),
                    ),
                ],
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              hiddenCameraDetected
                  ? "Hidden Camera Detected!"
                  : "No Hidden Camera Detected",
              style: TextStyle(
                color: hiddenCameraDetected ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final Rect rect;
  final double imgWidth;
  final double imgHeight;

  BoundingBoxPainter(this.rect, this.imgWidth, this.imgHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    double scaleX = size.width / imgWidth;
    double scaleY = size.height / imgHeight;

    Rect scaledRect = Rect.fromLTRB(
      rect.left * scaleX,
      rect.top * scaleY,
      rect.right * scaleX,
      rect.bottom * scaleY,
    );
    canvas.drawRect(scaledRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
*/
/*
//Rough pixels With Exposure and circle
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  bool hiddenCameraDetected = false;
  bool processing = false;
  Timer? timer;
  Rect? boundingBox;

  @override
  void initState() {
    super.initState();
    startCamera();
  }

  @override
  void dispose() {
    cameraController.dispose();
    timer?.cancel();
    super.dispose();
  }

  Future<void> startCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await cameraController.initialize();
    await cameraController.setFlashMode(FlashMode.off);

    timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (!processing) {
        processCameraFrame();
      }
    });

    setState(() {});
  }

  Future<void> processCameraFrame() async {
    processing = true;

    try {
      XFile imageFile = await cameraController.takePicture();
      List<int> imageBytes = await imageFile.readAsBytes();
      img.Image? decodedImage = img.decodeImage(imageBytes);
      if (decodedImage != null) {
        bool foundHighIntensity = checkForHighIntensityPixels(decodedImage);
        if (hiddenCameraDetected != foundHighIntensity) {
          setState(() {
            hiddenCameraDetected = foundHighIntensity;
          });
        }
      }
    } catch (e) {
      print("Error processing camera frame: $e");
    }
    processing = false;
  }

  bool checkForHighIntensityPixels(img.Image image) {
    int minX = image.width, minY = image.height;
    int maxX = 0, maxY = 0;
    bool found = false;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixel = image.getPixel(x, y);
        int red = img.getRed(pixel);
        int green = img.getGreen(pixel);
        int blue = img.getBlue(pixel);

        if (red > 250 && green > 250 && blue > 250) {
          minX = x < minX ? x : minX;
          minY = y < minY ? y : minY;
          maxX = x > maxX ? x : maxX;
          maxY = y > maxY ? y : maxY;
          found = true;
        }
      }
    }

    if (found) {
      boundingBox = Rect.fromLTRB(
        minX.toDouble(),
        minY.toDouble(),
        maxX.toDouble(),
        maxY.toDouble(),
      );

      double width = boundingBox!.width;
      double height = boundingBox!.height;
      double aspectRatio = width / height;

      // Check if the bounding box is roughly a square (round object)
      if (aspectRatio > 0.9 && aspectRatio < 1.1) {
        return true; // Detected round shape
      } else {
        boundingBox = null; // Ignore non-round shapes
        return false;
      }
    } else {
      boundingBox = null;
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Hidden Camera Detector",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          if (cameraController.value.isInitialized)
            Expanded(
              child: Stack(
                children: [
                  CameraPreview(cameraController),
                  if (boundingBox != null)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: BoundingBoxPainter(
                          boundingBox!,
                          cameraController.value.previewSize!.width,
                          cameraController.value.previewSize!.height,
                        ),
                      ),
                    ),
                ],
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              hiddenCameraDetected
                  ? "Hidden Camera Detected!"
                  : "No Hidden Camera Detected",
              style: TextStyle(
                color: hiddenCameraDetected ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final Rect rect;
  final double imgWidth;
  final double imgHeight;

  BoundingBoxPainter(this.rect, this.imgWidth, this.imgHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    double scaleX = size.width / imgWidth;
    double scaleY = size.height / imgHeight;

    Rect scaledRect = Rect.fromLTRB(
      rect.left * scaleX,
      rect.top * scaleY,
      rect.right * scaleX,
      rect.bottom * scaleY,
    );

    canvas.drawRect(scaledRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
*/

/*
//Pixel tested and before report button
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:audioplayers/audioplayers.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  bool hiddenCameraDetected = false;
  bool processing = false;
  Timer? timer;
  Rect? boundingBox;
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
    startCamera();
  }

  Future<void> plays() async{
    audioPlayer.play(AssetSource("sound/so.mp3"));
  }
  @override
  void dispose() {
    cameraController.dispose();
    timer?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> startCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await cameraController.initialize();
    await cameraController.setFlashMode(FlashMode.off);

    timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (!processing) {
        processCameraFrame();
      }
    });

    setState(() {});
  }

  Future<void> processCameraFrame() async {
    processing = true;

    try {
      XFile imageFile = await cameraController.takePicture();
      List<int> imageBytes = await imageFile.readAsBytes();
      img.Image? decodedImage = img.decodeImage(imageBytes);
      if (decodedImage != null) {
        bool foundCamera = checkForCircularReflectiveObjects(decodedImage);
        if (hiddenCameraDetected != foundCamera) {
          setState(() {
            hiddenCameraDetected = foundCamera;
            if (hiddenCameraDetected) {
              plays(); // Play audio if hidden camera is detected
            } else {
              audioPlayer.stop(); // Stop audio if hidden camera is not detected
            }
          });
        }
      }
    } catch (e) {
      print("Error processing camera frame: $e");
    }
    processing = false;
  }

  bool checkForCircularReflectiveObjects(img.Image image) {
    int minX = image.width, minY = image.height;
    int maxX = 0, maxY = 0;
    bool found = false;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixel = image.getPixel(x, y);
        int red = img.getRed(pixel);
        int green = img.getGreen(pixel);
        int blue = img.getBlue(pixel);

        if (red > 250 && blue > 15 && 110> green && green>90) { //red > 240 && green > 240 && blue > 240
        minX = x < minX ? x : minX;
          minY = y < minY ? y : minY;
          maxX = x > maxX ? x : maxX;
          maxY = y > maxY ? y : maxY;
          found = true;
          plays();
        }
      }
    }

    if (found) {
      boundingBox = Rect.fromLTRB(
        minX.toDouble(),
        minY.toDouble(),
        maxX.toDouble(),
        maxY.toDouble(),
      );

      return isCircular(minX, minY, maxX, maxY);
    } else {
      boundingBox = null;
      return false;
    }
  }

  bool isCircular(int minX, int minY, int maxX, int maxY) {
    int width = maxX - minX;
    int height = maxY - minY;

    double aspectRatio = width / height;
    return aspectRatio > 0.8 && aspectRatio < 1.2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Hidden Camera Detector",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          if (cameraController.value.isInitialized)
            Expanded(
              child: Stack(
                children: [
                  CameraPreview(cameraController),
                  if (boundingBox != null)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: BoundingBoxPainter(
                          boundingBox!,
                          cameraController.value.previewSize!.width,
                          cameraController.value.previewSize!.height,
                        ),
                      ),
                    ),
                ],
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              hiddenCameraDetected
                  ? "Hidden Camera Detected!"
                  : "No Hidden Camera Detected",
              style: TextStyle(
                color: hiddenCameraDetected ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final Rect rect;
  final double imgWidth;
  final double imgHeight;

  BoundingBoxPainter(this.rect, this.imgWidth, this.imgHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    double scaleX = size.width / imgWidth;
    double scaleY = size.height / imgHeight;

    Rect scaledRect = Rect.fromLTRB(
      rect.left * scaleX,
      rect.top * scaleY,
      rect.right * scaleX,
      rect.bottom * scaleY,
    );

    canvas.drawRect(scaledRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:audioplayers/audioplayers.dart';


import 'Database Helper.dart';
import 'Model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  bool hiddenCameraDetected = false;
  bool processing = false;
  Timer? timer;
  Rect? boundingBox;
  AudioPlayer audioPlayer = AudioPlayer();
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    startCamera();
  }

  // Future<void> plays() async {
  //   audioPlayer.play(AssetSource("sound/so.mp3"));
  // }
  void plays(){
    audioPlayer.play(AssetSource("sound/so.mp3"));
  }

  @override
  void dispose() {
    cameraController.dispose();
    timer?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> startCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await cameraController.initialize();
    await cameraController.setFlashMode(FlashMode.off);

    timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (!processing) {
        processCameraFrame();
      }
    });

    setState(() {});
  }

  Future<void> processCameraFrame() async {
    processing = true;

    try {
      XFile imageFile = await cameraController.takePicture();
      List<int> imageBytes = await imageFile.readAsBytes();
      img.Image? decodedImage = img.decodeImage(imageBytes);
      if (decodedImage != null) {
        bool foundCamera = checkForCircularReflectiveObjects(decodedImage);
        if (hiddenCameraDetected != foundCamera) {
          setState(() {
            hiddenCameraDetected = foundCamera;
            if (hiddenCameraDetected) {
              plays();
            } else {
              audioPlayer.stop();
            }
          });
        }
      }
    } catch (e) {
      print("Error processing camera frame: $e");
    }
    processing = false;
  }

  bool checkForCircularReflectiveObjects(img.Image image) {
    int minX = image.width, minY = image.height;
    int maxX = 0, maxY = 0;
    bool found = false;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixel = image.getPixel(x, y);
        int red = img.getRed(pixel);
        int green = img.getGreen(pixel);
        int blue = img.getBlue(pixel);

        //if (red > 250 && blue > 15 && green > 90 && green < 110) {
        if (red > 250 && blue > 240 && green > 240) {
          minX = x < minX ? x : minX;
          minY = y < minY ? y : minY;
          maxX = x > maxX ? x : maxX;
          maxY = y > maxY ? y : maxY;
          found = true;
        }
      }
    }

    if (found) {
      boundingBox = Rect.fromLTRB(
        minX.toDouble(),
        minY.toDouble(),
        maxX.toDouble(),
        maxY.toDouble(),
      );

      return isCircular(minX, minY, maxX, maxY);
    } else {
      boundingBox = null;
      return false;
    }
  }

  bool isCircular(int minX, int minY, int maxX, int maxY) {
    int width = maxX - minX;
    int height = maxY - minY;

    double aspectRatio = width / height;
    return aspectRatio > 0.8 && aspectRatio < 1.2;
  }

  Future<void> showReportFormDialog() async {
    final TextEditingController locationController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Hidden Camera'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              String location = locationController.text;
              String description = descriptionController.text;

              if (location.isNotEmpty && description.isNotEmpty) {
                await dbHelper.insertReport(Report(
                  location: location,
                  date: DateTime.now().toIso8601String(),
                  description: description,
                  reportCount: 1,
                ).toMap());

                Navigator.pop(context);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Hidden Camera Detector",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          if (cameraController.value.isInitialized)
            Expanded(
              child: Stack(
                children: [
                  CameraPreview(cameraController),
                  if (boundingBox != null)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: BoundingBoxPainter(
                          boundingBox!,
                          cameraController.value.previewSize!.width,
                          cameraController.value.previewSize!.height,
                        ),
                      ),
                    ),
                ],
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              hiddenCameraDetected
                  ? "Hidden Camera Detected!"
                  : "No Hidden Camera Detected",
              style: TextStyle(
                color: hiddenCameraDetected ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showReportFormDialog,
        backgroundColor: Colors.red,
        child: const Icon(Icons.report),
      ),
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final Rect rect;
  final double imgWidth;
  final double imgHeight;

  BoundingBoxPainter(this.rect, this.imgWidth, this.imgHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    double scaleX = size.width / imgWidth;
    double scaleY = size.height / imgHeight;

    Rect scaledRect = Rect.fromLTRB(
      rect.left * scaleX,
      rect.top * scaleY,
      rect.right * scaleX,
      rect.bottom * scaleY,
    );

    canvas.drawRect(scaledRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
