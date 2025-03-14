// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:image/image.dart' as img;
// import 'package:flutter/material.dart';
// class process extends StatefulWidget {
//   final XFile image;
//   process({required this.image, super.key});
//
//   @override
//   State<process> createState() => _processState();
// }
//
// class _processState extends State<process> {
//   bool found = false;
//   @override
//   void initState() {
//     super.initState();
//     processimg();
//   }
//   void processimg() async{
//     // Step 1: Load the image from XFile
//     File imageFile = File(widget.image.path);
//     List<int> imageBytes = await imageFile.readAsBytes();
//
//     // Step 2: Decode the image using the image package
//     img.Image? decodedImage = img.decodeImage(imageBytes);
//
//     if (decodedImage != null) {
//       // Step 3: Loop through the image pixels
//       for (int y = 0; y < decodedImage.height; y++) {
//         for (int x = 0; x < decodedImage.width; x++) {
//           // Step 4: Get pixel value at (x, y)
//           int pixel = decodedImage.getPixel(x, y);
//
//           // Step 5: Extract red, green, and blue components
//           int red = img.getRed(pixel);
//           int green = img.getGreen(pixel);
//           int blue = img.getBlue(pixel);
//
//           // Step 6: Check if the pixel matches the specified intensity ranges
//           if (red >= 220 && green >= 180  && blue >= 180) {
//             print('Found matching pixel at ($x, $y): R=$red, G=$green, B=$blue');
//             setState(() {
//               found = true;
//             });
//             break; // Stop after finding the first matching pixel
//           }
//         }
//         if (found) break;
//       }
//
//       if (!found) {
//         print('No matching pixel found.');
//       }
//     } else {
//       print('Error decoding image.');
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     File img1 = File(widget.image.path);
//     if (found){
//       return Scaffold(
//         appBar: AppBar(title: Text("Found"),),
//         body: Center(child: Image.file(img1),),
//       );
//     }
//     return const Placeholder();
//   }
//   }
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
class Process extends StatefulWidget {
  final XFile image;
  Process({required this.image, super.key});

  @override
  State<Process> createState() => _ProcessState();
}

class _ProcessState extends State<Process> {
  bool found = false;
  Rect? boundingBox;
  final AudioPlayer audioPlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
    processImg();
  }

  Future<void> plays() async{
    await audioPlayer.play(AssetSource("sound/so.mp3"));
  }

  void processImg() async {
    // Step 1: Load the image from XFile
    File imageFile = File(widget.image.path);
    List<int> imageBytes = await imageFile.readAsBytes();

    // Step 2: Decode the image using the image package
    img.Image? decodedImage = img.decodeImage(imageBytes);

    if (decodedImage != null) {
      int minX = decodedImage.width, minY = decodedImage.height;
      int maxX = 0, maxY = 0;
      int matchCount = 0;

      // Step 3: Loop through the image pixels
      for (int y = 0; y < decodedImage.height; y++) {
        for (int x = 0; x < decodedImage.width; x++) {
          // Step 4: Get pixel value at (x, y)
          int pixel = decodedImage.getPixel(x, y);

          // Step 5: Extract red, green, and blue components
          int red = img.getRed(pixel);
          int green = img.getGreen(pixel);
          int blue = img.getBlue(pixel);

          // Step 6: Check if the pixel matches the specified intensity ranges
          if (red >= 220 && green >= 180 && blue >= 180) {
            matchCount++;

            // Track the min and max coordinates of matching pixels
            if (x < minX) minX = x;
            if (y < minY) minY = y;
            if (x > maxX) maxX = x;
            if (y > maxY) maxY = y;

            // Stop after matching at least 5 neighbors (adjust as needed)
            if (matchCount >= 5) {
              boundingBox = Rect.fromLTRB(minX.toDouble(), minY.toDouble(),
                  maxX.toDouble(), maxY.toDouble());
              found = true;
              await plays();
              setState(() {});
              break;
            }
          }
        }
        if (found) break;
      }

      if (!found) {
        print('No matching pixels found.');
      }
    } else {
      print('Error decoding image.');
    }
  }
  @override
  void dispose() {
    audioPlayer.dispose(); // Dispose of the audio player
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    File imgFile = File(widget.image.path);

    return Scaffold(
      appBar: AppBar(
        title: Text(found ? "Found" : "Processing..."),
      ),
      body: Center(
        child: Stack(
          children: [
            Image.file(imgFile),
            if (found && boundingBox != null)
              Positioned.fill(
                child: CustomPaint(
                  painter: BoundingBoxPainter(boundingBox!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final Rect rect;
  BoundingBoxPainter(this.rect);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Scale the bounding box rectangle to fit the image size
    final scaledRect = Rect.fromLTRB(
      // rect.left * size.width / rect.width,
      // rect.top * size.height / rect.height,
      // rect.right * size.width / rect.width,
      // rect.bottom * size.height / rect.height,
      rect.left * size.width,
      rect.top * size.height,
      rect.right * size.width,
      rect.bottom * size.height,
    );

    canvas.drawRect(scaledRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
