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


        if (red > 250 && blue > 240 &&  green>240 ) {
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